{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  patchelf,
  glibc,
  libgcc,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  wayland,
  mesa,
  vulkan-loader,
  fontconfig,
  freetype,
  alsa-lib,
  ...
}:

# =============================================================================
# filmcraft – FilmCraft, an open-source video editor
# Upstream: https://github.com/storytold/filmcraft   (Apache-2.0 OR MIT)
#
# Part of the "Crafting Apps" suite from ArtCraft / storytold. Siblings packaged
# the same way in this directory: photocraft.nix, vectorcraft.nix, pdfcraft.nix.
# Installed together behind the `artcraft.enable` toggle in modules/artcraft.nix.
#
# -----------------------------------------------------------------------------
# WHY AN APPIMAGE-ONLY PACKAGE
# -----------------------------------------------------------------------------
# Upstream ships a full matrix per release (AppImage, .deb, .rpm, .flatpak,
# tar.gz, macOS dmg, Windows msi/zip, plus a -web wasm zip and a -cli zip).
# None of those are nix packages. The AppImage is the right source for Nix for
# the same reason nixpkgs' revolt-desktop / heynote use it:
#
#   1. `appimageTools.extract` unsquashes it at BUILD time, so nothing needs
#      FUSE, squashfs mounts or bubblewrap at run time. This config has no
#      `boot.kernelParams = [ "fuse.allow_other" ]`, so a FUSE-mounted AppImage
#      would be the fragile choice here.
#   2. The payload is a plain static-pie Rust binary – no Electron, no webview,
#      no interpreter, no JRE. Upstream is explicit about that in their AGENTS.md
#      ("no Tauri, Electron or webview shells").
#
# -----------------------------------------------------------------------------
# WHAT WE ACTUALLY TAKE FROM THE SQUASHFS (verified on v0.4.0)
# -----------------------------------------------------------------------------
#   usr/bin/filmcraft       the GUI. `Exec=filmcraft %F` is a bare command name,
#                            so installing to $out/bin/filmcraft needs NO desktop
#                            rewriting (unlike neo-writer.nix, whose AppImage
#                            points Exec at AppRun).
#   usr/bin/filmcraft-cli   headless CLI plus `serve` and `mcp`.
#   usr/share/icons/hicolor/ 16..512 px PNGs + a scalable SVG. NOTE: filmcraft
#                            is the one app in the suite whose icons also ship
#                            `.attribution` sidecars (CC-BY artwork), and we copy
#                            the whole tree so those are kept.
#   usr/share/metainfo/ai.storyteller.filmcraft.metainfo.xml
#   usr/share/mime/packages/ai.storyteller.filmcraft.xml
#
# NOT copied: `AppRun` (a hardlink of the same GUI binary) and the duplicate
# top-level `ai.storyteller.filmcraft.{desktop,png}` / `.DirIcon` copies.
#
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# RUNTIME DEPS – why this file patches the ELF (do not "simplify" this away)
# -----------------------------------------------------------------------------
# Upstream builds on Ubuntu and ships a generic binary. `ldd` on it shows only
# these NEEDED libs:
#     libasound.so.2       <-- the extra one
#     libgcc_s.so.1, libm.so.6, libc.so.6
# and the ELF interpreter is the generic /lib64/ld-linux-x86-64.so.2.
#
# Everything else is dlopen()ed at run time, which ldd cannot show:
#     libX11.so.6, libXcursor.so.1, libXi.so.6, libX11-xcb.so.1, libxcb.so.1,
#     libwayland-client.so.0, libwayland-egl.so.1, libxkbcommon.so.0,
#     libEGL.so.1, libvulkan.so.1, libfontconfig.so.1, libfreetype.so.6
#
# filmcraft is also the one app in the suite that links ALSA directly (the
# scopes / program-monitor audio path), so libasound.so.2 is a real DT_NEEDED
# here rather than a dlopen. It goes into runtimeInputs below like everything
# else, which is why this file no longer needs a makeWrapper.
#
# Left alone, that binary only runs on NixOS by ACCIDENT: the kernel resolves
# /lib64/ld-linux-x86-64.so.2 through /usr/lib symlinks that some other package
# in the closure happens to create, and the dlopen()s land there too. Those
# symlinks come and go with unrelated packages, so the app "works" until a
# rebuild removes them and then fails with:
#     Could not start dynamically linked executable: filmcraft
#     NixOS cannot run dynamically linked executables intended for generic
#     linux environments out of the box.
#
# So installPhase rewrites both binaries to be genuinely Nix-native:
#   1. --set-interpreter to Nix glibc's ld.so, so the kernel never has to find
#      a generic /lib64 path.
#   2. --set-rpath to an explicit store path per library above, so every
#      dlopen() resolves out of this package's own closure and never touches
#      /usr/lib.
# With that, the binary is self-contained, needs no wrapper script, and keeps
# working when unrelated packages come and go. See runtimeInputs below.
# -----------------------------------------------------------------------------
# AUDIO IN PRACTICE ON THIS BOX
# -----------------------------------------------------------------------------
# PipeWire is running (modules/audio.nix) and PipeWire owns the ALSA devices, so
# libasound is only ever an enabler for the PipeWire ALSA plugin. If scopes are
# silent after installing, check `pw-cli list-objects | grep -i alsa` before
# suspecting this package.
#
# -----------------------------------------------------------------------------
# GPU ON THIS MACHINE – read this before blaming the app for being slow
# -----------------------------------------------------------------------------
# This box is an Intel Pentium G630 (Sandy Bridge, gen6) with HD Graphics 2000.
# Verified on it:
#   * `vulkaninfo --summary` reports exactly one device:
#       llvmpipe (LLVM 21.1.8, 128 bits) / PHYSICAL_DEVICE_TYPE_CPU
#     i.e. software Vulkan. Mesa's Intel ANV driver needs Broadwell/Haswell
#     (gen8+), so there is no hardware Vulkan here.
#   * The apps still enumerate a GL adapter – they log
#       "Mesa Intel(R) HD Graphics 2000 (SNB GT1) (Gl, IntegratedGpu)"
#     because EGL reports the DRM node. But /run/opengl-driver/lib/dri has no
#     i965_dri.so (Mesa 26 dropped it), so the draws themselves land on
#     llvmpipe. The name is real; the silicon is not doing the work.
#   * So: wgpu takes the Vulkan path and gets a CPU device. Rendering is
#     correct and it is not going to crash — it is just CPU-bound on 2 cores.
# # This is the one to watch. A video editor needs a real-time decode+composite
# pipeline; with no decode engine and software rendering over 2 Sandy Bridge
# cores, HD playback will drop frames. Cut and export short clips at modest
# resolutions. This is the hardware, not this package.
# A zbus warning about org.freedesktop.DBus at startup is normal and harmless
# here (xdg-desktop-portal not up yet); the apps carry on.
# -----------------------------------------------------------------------------
# HOW TO UPDATE (manual-hash workflow – same as packages/kson-rs.nix)
# -----------------------------------------------------------------------------
# These apps release often (v0.2.1 -> v0.4.0 on the same day). To move forward:
#
# 1. Find the newest release and its x86_64 AppImage hash:
#      curl -s https://api.github.com/repos/storytold/filmcraft/releases/latest \
#        | jq -r '.tag_name, (.assets[] | select(.name|test("linux-x86_64.AppImage$")) | .name)'
#      curl -s https://github.com/storytold/filmcraft/releases/download/v<NEW>/SHA256SUMS.txt \
#        | grep linux-x86_64.AppImage
#
# 2. Update `version` below. The asset name is always
#    `${pname}-${version}-linux-x86_64.AppImage` (no `v` in the filename even
#    though the tag is `v<version>`).
#
# 3. Update `hash`. Easiest is to skip SHA256SUMS.txt entirely:
#      hash = lib.fakeHash;  then  nix build .#filmcraft
#    The mismatch error prints the exact `got: sha256-...` to paste back.
#
# 4. Re-check the squashfs layout if the table above stops matching, and re-run
#    `ldd` on the extracted usr/bin/filmcraft: if a second hard NEEDED library
#    appears beyond libc/libm/libgcc_s/librt/libpthread, add it to the
#    makeWrapper LD_LIBRARY_PATH line in postFixup the same way alsa-lib is.
#      nix build --no-link --print-out-paths --impure --expr '
#        let f = builtins.getFlake (toString ./.);
#        in f.inputs.nixpkgs.legacyPackages.x86_64-linux.appimageTools.extract {
#          pname = "filmcraft-probe"; version = "<NEW>";
#          src = f.inputs.nixpkgs.legacyPackages.x86_64-linux.fetchurl {
#            url = "..."; hash = "sha256-..."; };
#        }'
#
# 5. Verify:
#      nix build .#filmcraft
#      ./result/bin/filmcraft-cli --help
#      ./result/bin/filmcraft
#      nixos-rebuild switch --flake .#dan
#
# Rollback: revert `version`/`hash` in git, or set `artcraft.enable = false` in
# modules/artcraft.nix and rebuild to drop the whole suite from the system.
#
# -----------------------------------------------------------------------------
# PLATFORM NOTE
# -----------------------------------------------------------------------------
# Upstream also ships an aarch64 AppImage. flake.nix hardcodes
# `system = "x86_64-linux"`, so we fetch the x86_64 file only.
# =============================================================================

let
  pname = "filmcraft";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/storytold/filmcraft/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    hash = "sha256-2EEN6nsrBk7eHq2H3YlLyjU3pN/aGkQpcViEn1a6LUw=";
  };

  # Unsquashed AppImage. The AppRun/squashfs bits are discarded by installPhase.
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
  # Everything the GUI and CLI need at run time, resolved into one RPATH.
  # glibc + libgcc cover the NEEDED libs; the rest cover the dlopen()s.
  # libxkbcommon also ships libxkbcommon-x11.so.0, which these apps need on the
  # X11 fallback path.
  # alsa-lib is here because the GUI binary has a hard NEEDED on it.
  runtimeInputs = [
    glibc
    libgcc
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    wayland
    mesa
    vulkan-loader
    fontconfig
    freetype
    alsa-lib
  ];
in
stdenvNoCC.mkDerivation rec {
  inherit pname version src;

  # The AppImage is an opaque binary; we install from `appimageContents` instead.
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  nativeBuildInputs = [ patchelf ];
  buildInputs = runtimeInputs;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share

    # Exec=filmcraft %F is already a bare command name, so the only thing the
    # wrapper below has to add is the ALSA lib path.
    install -Dm755 ${appimageContents}/usr/bin/$pname     $out/bin/$pname
    install -Dm755 ${appimageContents}/usr/bin/$pname-cli $out/bin/$pname-cli

    # Make the upstream ELF Nix-native: a Nix glibc interpreter plus an RPATH
    # that covers every NEEDED and dlopen()ed library. This is what keeps the
    # apps working when /usr/lib symlinks from other packages disappear.
    for bin in $pname $pname-cli; do
      patchelf \
        --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 \
        --set-rpath ${lib.makeLibraryPath runtimeInputs} \
        "$out/bin/$bin"
    done


    # Whole trees, so icon sizes, the CC-BY .attribution sidecars and the MIME
    # registrations survive upstream growth.
    cp -a ${appimageContents}/usr/share/icons    $out/share/icons
    cp -a ${appimageContents}/usr/share/metainfo $out/share/metainfo
    cp -a ${appimageContents}/usr/share/mime     $out/share/mime
    install -Dm644 \
      ${appimageContents}/usr/share/applications/ai.storyteller.$pname.desktop \
      $out/share/applications/$pname.desktop

    # Sanity: fail at build time, not with a cryptic exec error at run time.
    test -x $out/bin/$pname
    test -x $out/bin/$pname-cli
    test -f $out/share/applications/$pname.desktop
    grep -q "^Exec=$pname %F" $out/share/applications/$pname.desktop

    for bin in $pname $pname-cli; do
      patchelf --print-interpreter "$out/bin/$bin" \
        | grep -q "${glibc}/lib/ld-linux-x86-64.so.2"
    done

    runHook postInstall
  '';

  # Belt and braces: after the package is realised, prove it links with NOTHING
  # from the host. A stray DT_NEEDED left unresolved would only show up at run
  # time as the generic-dynamic-executable error this file exists to prevent.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export LD_LIBRARY_PATH=""
    ldd $out/bin/$pname     > /dev/null
    ldd $out/bin/$pname-cli > /dev/null
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Open-source video editor with a multi-track timeline, video scopes and a CLI/MCP automation interface";
    homepage = "https://github.com/storytold/filmcraft";
    downloadPage = "https://github.com/storytold/filmcraft/releases";
    changelog = "https://github.com/storytold/filmcraft/releases";
    license = licenses.asl20; # dual Apache-2.0 OR MIT
    mainProgram = pname;
    platforms = platforms.linux;
    # Prebuilt x86_64 Rust binaries from GitHub releases, so flag the provenance.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
