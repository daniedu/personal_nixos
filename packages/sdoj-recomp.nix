{ lib
, stdenv
, llvmPackages_20
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, makeWrapper
, autoPatchelfHook
, python3
, gtk3
, libx11
, libxcb
, vulkan-loader
, alsa-lib
, libpulseaudio
, pipewire
}:

# =============================================================================
# SDOJ-Recomp – DoDonPachi Saidaioujou Recompilation (ReXGlue)
# Upstream: https://github.com/eandis/SDOJ-Recomp (no LICENSE, treat as unfree)
#   SDK: thirdparty/rexglue-sdk BSD-3-Clause (bundled 0.8.1.4)
#   Requires user-provided Xbox 360 dump + TU 1.01 – NOT bundled.
#
# Binary produced:
#   - saidaioujou_recomp_tu1  (src/main.cpp -> add_executable, CMakeLists.txt:11)
#   - guest DLLs: libsaidaioujou_recomp_tu1_CA022100.so / CA022110.so (dll_targets.cmake)
#   - SDK runtime: librexruntime.so + libTracyClient.so (thirdparty/rexglue-sdk/out/linux-amd64)
#   All in out/build/linux-amd64-release/ after `cmake --preset linux-amd64-release`.
#   No `install()` rules upstream – we copy manually.
#
# Wrapper: $out/bin/sdoj-recomp -> ~/Games/SDOJ (see postInstall)
#   The original launcher/launch.sh:8 expects ROOT beside exe and does
#   `prepare_game.sh --prepare-only` then exec with --game_data_root="$ROOT/game_data".
#   In Nix store that path is read-only, so wrapper redirects to writable
#   $HOME/Games/SDOJ and emulates ROOT by symlinking/copying the store files
#   there on first run (see postInstall wrapper script). User puts ISO + TU
#   in ~/Games/SDOJ as per README:First launch.
#
# -----------------------------------------------------------------------------
# HOW TO UPDATE (manual-hash workflow – same as packages/kson-rs.nix)
# -----------------------------------------------------------------------------
# 1. Pick new commit – latest main HEAD:
#      curl -s https://api.github.com/repos/eandis/SDOJ-Recomp/commits/main | jq -r '.sha'
#    Or:  nix run nixpkgs#nix-prefetch-github -- eandis SDOJ-Recomp --rev <REV>
#
# 2. Update `rev` below and `version` date.
#
# 3. Get new `hash` for fetchFromGitHub:
#      nix run nixpkgs#nix-prefetch-github -- eandis SDOJ-Recomp --rev <NEW_REV>
#    Replace `hash = "sha256-..."`. Tip: set `hash = lib.fakeHash;` then `nix build .#sdoj-recomp` prints expected.
#
# 4. If upstream bumps ReXGlue SDK vendored version, no action – it's vendored in thirdparty/.
#    If `extract-xiso` tool rev changes, bump its hash in `extractXiso` let below similarly.
#
# 5. If SDK bumps Clang requirement (currently >=18, we use llvmPackages_20), bump llvmPackages_20 -> 21 if needed.
#    Check thirdparty/rexglue-sdk/CMakeLists.txt `FATAL_ERROR` Clang version.
#
# 6. Verify:
#      nix build .#sdoj-recomp
#      ./result/bin/sdoj-recomp --help  # wrapper prints usage, underlying --help via --help passthrough
#      ldd ./result/bin/saidaioujou_recomp_tu1
#
# Rollback: revert rev/hash.
# =============================================================================

let
  # --- extract-xiso tool (required by prepare_game.sh) ---
  # Not in SDOJ repo – we build from XboxDev/extract-xiso.
  # Kept here to avoid extra flake input; update hash as in steps 3-4 above.
  extractXiso = stdenv.mkDerivation {
    pname = "extract-xiso";
    version = "unstable-2025-05-15";
    src = fetchFromGitHub {
      owner = "XboxDev";
      repo = "extract-xiso";
      rev = "b72e5b60d598ec6df80534cda19cdcd4361aa18c";
      hash = "sha256-KZxnS63MhpmzwxCPFi+op5l/vM6P9GYc+SXmNFmEyc8=";
    };
    nativeBuildInputs = [ cmake ];
    # Upstream README: mkdir build && cmake .. && make
    # CMakeLists.txt builds `extract-xiso` executable.
    cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];
  };
in
stdenv.mkDerivation rec {
  pname = "sdoj-recomp";
  version = "unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "eandis";
    repo = "SDOJ-Recomp";
    rev = "27e744f7282939cebf61aae3b70ac9c52440091f";
    hash = "sha256-WAZ8v3e9KwpIiXdnE0wJw6EfeR6zvbDQHHAvrCVoY68=";
    fetchSubmodules = false; # SDK is vendored copy, not submodule
  };

  # Use Clang stdenv – SDK enforces Clang >=18, fails on GCC.
  # We keep default stdenv but ensure clang in PATH and set CC/CXX via preset.
  nativeBuildInputs = [
    llvmPackages_20.clang
    cmake
    ninja
    pkg-config
    python3 # for spirv-tools (FindPython3) in thirdparty/rexglue-sdk
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3          # pkg_check_modules(GTK3 gtk+-3.0) in src/ui/CMakeLists.txt + rexglue_helpers.cmake
    libx11        # x11-xcb -> libx11 + libxcb (libx11-xcb-dev)
    libxcb
    vulkan-loader # runtime dlopen via volk (vendored headers), needed at runtime for libvulkan.so.1
    alsa-lib      # SDL3 ALSA shared dlopen (SDL_ALSA_SHARED ON)
    libpulseaudio # SDL3 Pulse shared
    pipewire      # SDL3 PipeWire shared
  ];

  # Preset already sets CMAKE_C_COMPILER=clang, CMAKE_CXX_COMPILER=clang++, generator Ninja.
  # We also ensure clang is found in sandbox.
  # Disable Tracy to drop libTracyClient.so from closure (optional):
  # cmakeFlags = [ "-DREXGLUE_ENABLE_TRACY=OFF" ];

  # ------------------------------------------------------------
  # Configure & Build – mirrors README: cmake --preset linux-amd64-release
  # ------------------------------------------------------------
  # We use the preset directly; it sets BinaryDir out/build/linux-amd64-release
  configurePhase = ''
    runHook preConfigure
    cmake --preset linux-amd64-release
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build --preset linux-amd64-release --parallel $NIX_BUILD_CORES
    runHook postBuild
  '';

  # ------------------------------------------------------------
  # Install – no install() rules upstream, copy manually like CI:
  #   find out/build/linux-amd64-release -maxdepth 1 -name 'saidaioujou_recomp_tu1' -o -name '*.so*'
  # Plus SDK runtime libs from thirdparty/rexglue-sdk/out/linux-amd64/
  # ------------------------------------------------------------
  installPhase = ''
    runHook preInstall

    # Main executable
    install -Dm755 out/build/linux-amd64-release/saidaioujou_recomp_tu1 $out/bin/saidaioujou_recomp_tu1

    # Guest DLLs colocated via rexglue_configure_module_target HOST
    for so in out/build/linux-amd64-release/*.so*; do
      if [ -f "$so" ]; then
        install -Dm755 "$so" "$out/lib/$(basename "$so")"
        # Also link in bin for $ORIGIN RPATH fallback
        ln -sf "$out/lib/$(basename "$so")" "$out/bin/$(basename "$so")"
      fi
    done

    # SDK runtime libs – built as part of same CMake (thirdparty/rexglue-sdk/out/linux-amd64)
    # README says to copy librexruntime.so + libTracyClient.so into build output
    for so in thirdparty/rexglue-sdk/out/linux-amd64/*.so*; do
      if [ -f "$so" ]; then
        install -Dm755 "$so" "$out/lib/$(basename "$so")"
        ln -sf "$out/lib/$(basename "$so")" "$out/bin/$(basename "$so")"
      fi
    done
    # Fallback: also check build dir if SDK already copied there
    for so in out/build/linux-amd64-release/lib*.so*; do
      if [ -f "$so" ]; then
        install -Dm755 -t $out/lib "$so" || true
      fi
    done

    # Launcher scripts (for reference, wrapper will emulate them)
    install -Dm755 launcher/launch.sh $out/share/sdoj-recomp/launch.sh
    install -Dm755 launcher/prepare_game.sh $out/share/sdoj-recomp/prepare_game.sh
    install -Dm755 launcher/launch.bat $out/share/sdoj-recomp/launch.bat  # unused on linux
    install -Dm755 launcher/prepare_game.ps1 $out/share/sdoj-recomp/prepare_game.ps1

    # extract-xiso tool (required by prepare_game.sh)
    mkdir -p $out/share/sdoj-recomp/tools/extract-xiso
    install -Dm755 ${extractXiso}/bin/extract-xiso $out/share/sdoj-recomp/tools/extract-xiso/extract-xiso
    # Also provide in libexec for wrapper symlink
    mkdir -p $out/libexec
    ln -sf $out/share/sdoj-recomp/tools/extract-xiso/extract-xiso $out/libexec/extract-xiso

    # Make sure executable finds libs via RPATH or LD_LIBRARY_PATH
    # autoPatchelfHook will patch, but we also wrap.

    runHook postInstall
  '';

  postFixup = ''
    # Wrap the raw binary for LD_LIBRARY_PATH (gtk3, vulkan-loader, alsa etc.)
    # This is the low-level binary; the high-level $out/bin/sdoj-recomp wrapper below handles ~/Games/SDOJ
    wrapProgram $out/bin/saidaioujou_recomp_tu1 \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}:$out/lib" \
      --set GDK_BACKEND x11

    # ------------------------------------------------------------
    # High-level wrapper: `sdoj-recomp` -> ~/Games/SDOJ
    # ------------------------------------------------------------
    # Original launch.sh: ROOT="$(dirname $0)", prepare_game.sh --prepare-only, exec binary --game_data_root="$ROOT/game_data"
    # Store ROOT is read-only, so we redirect to writable $HOME/Games/SDOJ and emulate ROOT by symlinking store files there.
    cat > $out/bin/sdoj-recomp <<'WRAPPER'
#!/usr/bin/env bash
set -e
GAME_ROOT="$HOME/Games/SDOJ"
STORE_SHARE="@out@/share/sdoj-recomp"
STORE_BIN="@out@/bin"
STORE_LIB="@out@/lib"

mkdir -p "$GAME_ROOT"
mkdir -p "$GAME_ROOT/game_data" "$GAME_ROOT/user_data" "$GAME_ROOT/tools/extract-xiso"

# Symlink runtime files into GAME_ROOT so prepare_game.sh sees ROOT == GAME_ROOT
# (prepare_game.sh does ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")" && pwd -P)")
for f in saidaioujou_recomp_tu1 librexruntime.so libTracyClient.so libsaidaioujou_recomp_tu1_CA022100.so libsaidaioujou_recomp_tu1_CA022110.so; do
  # try bin then lib
  if [ -f "$STORE_BIN/$f" ]; then
    ln -sf "$STORE_BIN/$f" "$GAME_ROOT/$f"
  elif [ -f "$STORE_LIB/$f" ]; then
    ln -sf "$STORE_LIB/$f" "$GAME_ROOT/$f"
  fi
  # also handle versioned .so.* symlinks
  for so in "$STORE_LIB/$f"* "$STORE_BIN/$f"*; do
    [ -e "$so" ] || continue
    base="$(basename "$so")"
    [ -f "$GAME_ROOT/$base" ] || ln -sf "$so" "$GAME_ROOT/$base"
  done
done

# Ensure extract-xiso at expected relative path $ROOT/tools/extract-xiso/extract-xiso
if [ ! -f "$GAME_ROOT/tools/extract-xiso/extract-xiso" ]; then
  mkdir -p "$GAME_ROOT/tools/extract-xiso"
  ln -sf "$STORE_SHARE/tools/extract-xiso/extract-xiso" "$GAME_ROOT/tools/extract-xiso/extract-xiso"
fi

# Install prepare script into GAME_ROOT so its ROOT resolves to GAME_ROOT
if [ ! -f "$GAME_ROOT/prepare_game.sh" ] || [ "$STORE_SHARE/prepare_game.sh" -nt "$GAME_ROOT/prepare_game.sh" ]; then
  cp -f "$STORE_SHARE/prepare_game.sh" "$GAME_ROOT/prepare_game.sh"
  chmod +x "$GAME_ROOT/prepare_game.sh"
fi

# Also ensure a copy of the launcher's default args is visible
if [ -f "$STORE_SHARE/launch.sh" ] && [ ! -f "$GAME_ROOT/launch.sh" ]; then
  cp "$STORE_SHARE/launch.sh" "$GAME_ROOT/launch.sh"
fi

# Run first-launch setup (ISO extraction + TU patch) – idempotent, skips if game_data already valid
if [ -f "$GAME_ROOT/prepare_game.sh" ]; then
  "$GAME_ROOT/prepare_game.sh" --prepare-only || {
    echo ""
    echo "Setup failed. Check ~/Games/SDOJ for:"
    echo "  - Disc:  SDOJ.iso + TU_11LK1V7_* file  (or TU_* 598016 bytes container)"
    echo "  - GoD:   GoD.iso + CA022100.binp / CA022110.binp / default.xexp"
    echo "See https://github.com/eandis/SDOJ-Recomp#first-launch"
    exit 1
  }
fi

# Finally exec the game with writable roots (like launch.sh but using GAME_ROOT)
cd -- "$GAME_ROOT" || exit 1
exec "$GAME_ROOT/saidaioujou_recomp_tu1" \
  --input_backend=sdl \
  --vsync=false \
  --fullscreen=true \
  --video_mode_refresh_rate=60 \
  --xex_apply_patches=true \
  --game_data_root="$GAME_ROOT/game_data" \
  --user_data_root="$GAME_ROOT/user_data" \
  --input_patch=true \
  --render_patch=true \
  "$@"
WRAPPER

    # Substitute @out@ placeholder
    substituteInPlace $out/bin/sdoj-recomp --replace-fail "@out@" "$out"
    chmod +x $out/bin/sdoj-recomp

    # Also provide a desktop entry
    mkdir -p $out/share/applications
    cat > $out/share/applications/sdoj-recomp.desktop <<EOF
[Desktop Entry]
Name=SDOJ Recomp
Comment=DoDonPachi Saidaioujou Recompilation (requires dump)
Exec=$out/bin/sdoj-recomp
Icon=applications-games
Terminal=false
Type=Application
Categories=Game;
Path=$HOME/Games/SDOJ
EOF

    # Keep raw binary also wrapped (already done) – but ensure sdoj-recomp gets libs too
    wrapProgram $out/bin/sdoj-recomp --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}:$out/lib" --set GDK_BACKEND x11
  '';

  meta = with lib; {
    description = "DoDonPachi Saidaioujou Recompilation via ReXGlue (requires user-provided Xbox 360 dump + TU 1.01)";
    homepage = "https://github.com/eandis/SDOJ-Recomp";
    license = licenses.unfree; # no LICENSE file upstream, game data is unfree; SDK is BSD-3 but overall unfree due to dump requirement
    maintainers = [];
    platforms = platforms.linux;
    mainProgram = "sdoj-recomp";
    # Needs Clang C++23, ~5-10min build, ~2-4GB RAM
  };
}
