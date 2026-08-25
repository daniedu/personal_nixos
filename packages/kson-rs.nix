{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, cmake
, perl
, llvmPackages
, makeWrapper
# --- Runtime / link deps (see comments below) ---
, alsa-lib
, systemd
, gtk3
, glib
, dbus
, at-spi2-core
, libGL
, wayland
, libxkbcommon
, freetype
, fontconfig
, zlib
, hidapi
, sqlite
, libx11
, libxcursor
, libxrandr
, libxi
, libxinerama
, libxcb
, libxau
, libxdmcp
, openssl  # only for pkg-config fallback; game uses `vendored` feature so perl builds bundled openssl
}:

# =============================================================================
# kson-rs – KSON format / SDVX simulator (game + editor)
# Upstream: https://github.com/Drewol/kson-rs (no GitHub Releases)
#   Artefacts published at https://kson.dev/games as .deb/.AppImage
#   This package builds from source via `rustPlatform.buildRustPackage`.
#
# Binaries produced (only in `game/Cargo.toml`):
#   - `rusc`        -> the game  (game/src/main.rs, default-run="rusc")
#   - `kson-editor` -> the editor (game/src/bin/kson-editor.rs -> editor/src/lib.rs)
# Both share crate `rusc` 0.1.0 – we build `-p rusc` with `--features embed-assets`
# to embed `game/skins` + `game/fonts` via `include_dir` so no `/usr/lib/rusc`
# or portable copy logic is needed (see `game/src/installer.rs`).
#
# -----------------------------------------------------------------------------
# HOW TO UPDATE (manual-hash workflow – keeps flake inputs minimal, no fenix/crane)
# -----------------------------------------------------------------------------
# 1. Pick new commit – usually latest `master` HEAD:
#      curl -s https://api.github.com/repos/Drewol/kson-rs/commits/master \
#        | jq -r '.sha'
#    Or:  nix run nixpkgs#nix-prefetch-github -- Drewol kson-rs --rev master
#
# 2. Update `rev` below and `version` (use date of commit, e.g. unstable-YYYY-MM-DD).
#
# 3. Get new `hash` for `fetchFromGitHub`:
#      nix run nixpkgs#nix-prefetch-github -- Drewol kson-rs --rev <NEW_REV>
#    Replace `hash = "sha256-..."` with the printed value.
#    Tip: set `hash = lib.fakeHash;` then `nix build .#kson-rs` – error prints expected.
#
# 4. Get new `cargoHash` (hash of `cargo vendor`):
#      a) Set `cargoHash = lib.fakeHash;` below.
#      b) Run:  nix build .#kson-rs  # or: nix build .#nixosConfigurations.dan.config.environment.systemPackages
#      c) Copy `got:    sha256-...` from error -> paste as `cargoHash`.
#    `cargoHash` changes whenever `Cargo.lock` or any git dep changes.
#    Git deps in this repo (from Cargo.lock, 2026-08):
#      - Drewol/femtovg        (branch cache-experiment-1)
#      - asny/three-d          (rev 2683e0f)
#      - Drewol/egui_inspect
#      - Drewol/luals-gen
#      - EmbarkStudios/poll-promise
#      - Drewol/soundtouch-rs  (4c97156) + soundtouch submodule (cmake+bindgen)
#      - SpaceManiac/nfd-rs    (branch zenity, runtime needs `zenity` binary)
#    No separate `cargoLock.outputHashes` needed – `cargoHash` covers them via vendor.
#
# 5. If you see `LIBCLANG_PATH` / bindgen / cmake errors after update, check
#    `kson-rodio-sources` or `soundtouch-sys` bump – nativeBuildInputs already has
#    `llvmPackages.libclang`/`clang`/`cmake`. If MSRV bumped (see `mise.toml: rust = "1.92"`),
#    ensure `nixpkgs` rustc (`nix eval --raw nixpkgs#rustc.version`) >= that.
#    Current check: 1.94.1 on nixos-unstable (2026-08) satisfies 1.92.
#
# 6. Verify:
#      nix build .#kson-rs
#      ./result/bin/rusc --help
#      ./result/bin/kson-editor --help
#      nixos-rebuild dry-activate --flake .#dan   # or switch/test
#
# Rollback: revert `rev`/`hash`/`cargoHash` in git.
# =============================================================================

rustPlatform.buildRustPackage rec {
  pname = "kson-rs";
  # No tags upstream – use unstable date of pinned commit + short rev.
  # Update this date when bumping `rev`.
  version = "unstable-2026-08-09";

  # --- Step 1/2/3: bump rev + hash when updating ---
  src = fetchFromGitHub {
    owner = "Drewol";
    repo = "kson-rs";
    rev = "b5f19ebf7a9f70bf0d90e493728a79be918a3200";
    # nix run nixpkgs#nix-prefetch-github -- Drewol kson-rs --rev <rev>
    hash = "sha256-SteygE98rsaeQ2HamPC+vxIaq6dfOejRliIYAnNbCGs=";
    # Repo has no git submodules (soundtouch is a Cargo git dep, not a submodule)
    fetchSubmodules = false;
  };

  # --- Step 4: cargoHash -> `lib.fakeHash` trick ---
  # nix build .#kson-rs will print expected `got: sha256-...`
  # Updated 2026-08-25 for rev b5f19ebf7a9f70bf0d90e493728a79be918a3200
  cargoHash = "sha256-Lc7M3l0NPo52bc0xbFpEpGKKAodwqWA3X2BLHWmUdNQ=";

  # Only the `rusc` package contains binaries (both `rusc` + `kson-editor`).
  # Use `embed-assets` to bake game/skins + game/fonts into the binary
  # (avoids patching installer paths or installing to /usr/lib/rusc).
  cargoBuildFlags = [
    "-p"
    "rusc"
    "--features"
    "embed-assets"
  ];

  # `doCheck = false` – tests need network/audio/GPU, skip to speed up.
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    cmake          # soundtouch-sys (via kson-rodio-sources) + bzip2/lzma sys crates compile C
    perl           # openssl-sys vendored builds bundled openssl (game/Cargo.toml: features vendored)
    llvmPackages.clang
    llvmPackages.libclang  # for bindgen in soundtouch-sys
    makeWrapper
  ];

  buildInputs = [
    alsa-lib       # rodio/cpal -> alsa-sys (rodio playback)
    systemd        # libudev-sys via gilrs (gamepad hotplug) – provides libudev
    gtk3           # rfd file dialogs (xdg-desktop-portal), nfd zenity fallback needs gtk at runtime
    glib
    dbus
    at-spi2-core
    libGL          # glutin/glow/femtovg/three-d OpenGL context (libglvnd)
    wayland        # winit wayland backend (wayland-sys)
    libxkbcommon   # winit xkbcommon-dl
    freetype
    fontconfig
    zlib           # zip crate + image png
    hidapi         # hidlights HID lighting
    sqlite         # libsqlite3-sys via rusc_database/sqlx (alternatively bakes own sqlite)
    openssl        # system fallback, though `vendored` mostly ignores it
    # X11 deps for winit/glutin X11 backend (dlopen, but need link at build)
    libx11
    libxcursor
    libxrandr
    libxi
    libxinerama
    libxcb
    libxau
    libxdmcp
  ];

  # bindgen (soundtouch-sys) needs to find libclang.
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # For crates that use `pkg-config` to locate system libs.
  PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" buildInputs;

  # Ensure C++ stdlib linked for soundtouch (cmake builds libSoundTouch.a).
  # `clang` already provides it; no extra flags needed unless cross-compiling.

  postInstall = ''
    # Wrap both binaries so they find runtime libs (ALSA, wayland, GL, etc.)
    # even when not in systemPackages. Useful if installed via home.packages.
    for bin in rusc kson-editor; do
      if [ -e "$out/bin/$bin" ]; then
        wrapProgram "$out/bin/$bin" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
          --prefix PATH : "${lib.makeBinPath [ gtk3 ]}"
      fi
    done

    # Install desktop entries if you want app launcher integration.
    # Upstream uses `cargo-bundle` for .desktop – we provide minimal ones.
    mkdir -p $out/share/applications
    cat > $out/share/applications/rusc.desktop <<EOF
    [Desktop Entry]
    Name=USC (kson-rs)
    Comment=Unnamed SDVX Clone – KSON format
    Exec=$out/bin/rusc
    Icon=applications-games
    Terminal=false
    Type=Application
    Categories=Game;
    EOF
    cat > $out/share/applications/kson-editor.desktop <<EOF
    [Desktop Entry]
    Name=KSON Editor
    Comment=Chart editor for KSON format
    Exec=$out/bin/kson-editor
    Icon=applications-multimedia
    Terminal=false
    Type=Application
    Categories=AudioVideo;Development;
    EOF
  '';

  meta = with lib; {
    description = "KSON format library, chart editor and SDVX simulator (rusc game + kson-editor)";
    homepage = "https://github.com/Drewol/kson-rs";
    downloadPage = "https://kson.dev/games";
    license = licenses.mit;
    mainProgram = "rusc";
    maintainers = [];
    platforms = platforms.linux;
    # High build-time deps: cmake, clang, vendored openssl, lua, soundtouch
    # Needs ~4-8 GiB RAM, ~10 min on x86_64-linux.
  };
}
