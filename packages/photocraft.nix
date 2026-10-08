{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
}:

# =============================================================================
# photocraft – PhotoCraft, an open-source layered image / PSD editor
# Upstream: https://github.com/storytold/photocraft   (Apache-2.0 OR MIT)
#
# Part of the "Crafting Apps" suite from ArtCraft / storytold. Siblings packaged
# the same way in this directory: vectorcraft.nix, filmcraft.nix, pdfcraft.nix.
# Installed together behind the `artcraft.enable` toggle in modules/artcraft.nix.
#
# -----------------------------------------------------------------------------
# WHY AN APPIMAGE-ONLY PACKAGE
# -----------------------------------------------------------------------------
# Upstream ships a full matrix per release (AppImage, .deb, .rpm, .flatpak,
# tar.gz, FreeBSD tarball, macOS dmg, Windows msi/zip, plus a -web wasm zip and
# a -cli zip). None of those are nix packages. The AppImage is the right source
# for Nix for the same reason nixpkgs' revolt-desktop / heynote use it:
#
#   1. `appimageTools.extract` unsquashes it at BUILD time, so nothing needs
#      FUSE, squashfs mounts or bubblewrap at run time. This config has no
#      `boot.kernelParams = [ "fuse.allow_other" ]`, so a FUSE-mounted AppImage
#      would be the fragile choice here.
#   2. The payload is a plain static-pie Rust binary – no Electron, no webview,
#      no interpreter, no JRE. Upstream is explicit about that in their AGENTS.md
#      ("no Tauri, Electron or webview shells"), which is what makes the closure
#      small and honest.
#
# -----------------------------------------------------------------------------
# WHAT WE ACTUALLY TAKE FROM THE SQUASHFS (verified on v0.5.0)
# -----------------------------------------------------------------------------
#   usr/bin/photocraft       the GUI. `Exec=photocraft %F` in the .desktop is a
#                            bare command name, so installing to $out/bin/photocraft
#                            needs NO desktop rewriting (unlike neo-writer.nix,
#                            whose AppImage points Exec at AppRun).
#   usr/bin/photocraft-cli   headless CLI: convert / info / run / batch / droplet,
#                            plus `serve` (JSON control channel) and `mcp`
#                            (MCP server on stdio). Same CLI/MCP surface as the
#                            other three craft apps.
#   usr/share/icons/hicolor/ 16..512 px PNGs + a scalable SVG.
#   usr/share/metainfo/ai.storyteller.photocraft.metainfo.xml
#   usr/share/mime/packages/ai.storyteller.photocraft.xml
#                            registers image/vnd.adobe.photoshop, image/x-psd,
#                            image/x-psb, image/x-exr, image/avif, image/qoi, …
#                            (20 MIME types) – worth keeping, it is what makes
#                            "Open With / default app" work for .psd.
#
# NOT copied: `AppRun` (a hardlink of the same GUI binary) and the duplicate
# top-level `ai.storyteller.photocraft.{desktop,png}` / `.DirIcon` copies that
# AppImage's runtime expects to find at $APPDIR. Installing from
# `usr/share/**` gets us the same files without the AppImage runtime shim.
#
# -----------------------------------------------------------------------------
# RUNTIME DEPS – why this needs no wrapper at all
# -----------------------------------------------------------------------------
# `ldd` on usr/bin/photocraft gives exactly three NEEDED libs:
#   libgcc_s.so.1, libm.so.6, libc.so.6
# Everything else is dlopen()ed at run time, which we cannot see statically:
#   libX11.so.6, libXcursor.so.1, libXi.so.6, libX11-xcb.so.1, libxcb.so.1,
#   libwayland-client.so.0, libwayland-egl.so.1, libxkbcommon.so.0,
#   libEGL.so.1, libvulkan.so.1, libfontconfig.so.1, libfreetype.so.6
# All of those are already reachable on this system, so $out/bin/photocraft is
# the unwrapped upstream binary. Nothing else needed.
#
# (filmcraft is the one exception in the suite – it has a hard DT_NEEDED on
# libasound.so.2, so that file adds a makeWrapper.)
#
# -----------------------------------------------------------------------------
# GPU ON THIS MACHINE – read this before blaming the app for being slow
# -----------------------------------------------------------------------------
# This box is an Intel Pentium G630 (Sandy Bridge, gen6) with HD Graphics 2000.
#   * No Vulkan. Mesa's Intel ANV driver needs Broadwell/Haswell (gen8+).
#   * No hardware GL either. Mesa 26 has dropped the legacy i965 driver, so
#     /run/opengl-driver/lib/dri has no i965_dri.so – only swrast_dri.so.
#
# So the GPU compositor runs on Mesa's software stack: lavapipe (software
# Vulkan) or llvmpipe (software GL). Both are present and correct, they are
# just CPU-bound on 2 cores. Large canvases, big PSDs and GPU-heavy filters WILL
# feel slow, and that is the hardware, not this package. PhotoCraft does ship a
# no-GPU fallback path, and vulkaninfo should report a "llvmpipe" device.
#
# -----------------------------------------------------------------------------
# HOW TO UPDATE (manual-hash workflow – same as packages/kson-rs.nix)
# -----------------------------------------------------------------------------
# These apps release often (v0.3.0 -> v0.5.0 on the same day). To move forward:
#
# 1. Find the newest release and its x86_64 AppImage hash:
#      curl -s https://api.github.com/repos/storytold/photocraft/releases/latest \
#        | jq -r '.tag_name, (.assets[] | select(.name|test("linux-x86_64.AppImage$")) | .name)'
#      curl -s https://github.com/storytold/photocraft/releases/download/v<NEW>/SHA256SUMS.txt \
#        | grep linux-x86_64.AppImage
#
# 2. Update `version` below. The asset name is always
#    `${pname}-${version}-linux-x86_64.AppImage` (no `v` in the filename even
#    though the tag is `v<version>`) – only photocraft 0.3.0 shipped a .zsync
#    beside it, which we ignore since nix handles content-addressing.
#
# 3. Update `hash`. Easiest is to skip SHA256SUMS.txt entirely:
#      hash = lib.fakeHash;  then  nix build .#photocraft
#    The mismatch error prints the exact `got: sha256-...` to paste back.
#
# 4. Re-check the squashfs layout if the table above stops matching. All four
#    craft apps shipped an identical layout at v0.4-0.5; if `installPhase` fails
#    with "No such file or directory", unpack it and look:
#      nix build --no-link --print-out-paths --impure --expr '
#        let f = builtins.getFlake (toString ./.);
#        in f.inputs.nixpkgs.legacyPackages.x86_64-linux.appimageTools.extract {
#          pname = "photocraft-probe"; version = "<NEW>";
#          src = f.inputs.nixpkgs.legacyPackages.x86_64-linux.fetchurl {
#            url = "..."; hash = "sha256-..."; };
#        }'
#
# 5. Verify:
#      nix build .#photocraft
#      ./result/bin/photocraft-cli --help
#      ./result/bin/photocraft            # a window opens; check it says GPU
#      nixos-rebuild switch --flake .#dan
#
# Rollback: revert `version`/`hash` in git, or set `artcraft.enable = false` in
# modules/artcraft.nix and rebuild to drop the whole suite from the system.
#
# -----------------------------------------------------------------------------
# PLATFORM NOTE
# -----------------------------------------------------------------------------
# Upstream also ships an aarch64 AppImage. flake.nix hardcodes
# `system = "x86_64-linux"`, so we fetch the x86_64 file only. To go multi-arch,
# switch `src` to the per-`system` table style nixpkgs uses for revolt-desktop
# and prefetch the arm64 hash.
# =============================================================================

let
  pname = "photocraft";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/storytold/photocraft/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    hash = "sha256-9U2GOAcFO738/6DWJO9+SdP9QTEMe7Ht5IU29pkp0i8=";
  };

  # Unsquashed AppImage. The AppRun/squashfs bits are discarded by installPhase.
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
stdenvNoCC.mkDerivation rec {
  inherit pname version src;

  # The AppImage is an opaque binary; we install from `appimageContents` instead.
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share

    # Exec=photocraft %F is already a bare command name, so no wrapper and no
    # .desktop rewriting is needed here.
    install -Dm755 ${appimageContents}/usr/bin/$pname     $out/bin/$pname
    install -Dm755 ${appimageContents}/usr/bin/$pname-cli $out/bin/$pname-cli

    # Whole trees, so icon sizes and MIME registrations survive upstream growth.
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

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source layered image editor with PSD import/export, layers, masks, brush and type tools, and a CLI/MCP automation interface";
    homepage = "https://github.com/storytold/photocraft";
    downloadPage = "https://github.com/storytold/photocraft/releases";
    changelog = "https://github.com/storytold/photocraft/releases";
    license = licenses.asl20; # dual Apache-2.0 OR MIT
    mainProgram = pname;
    platforms = platforms.linux;
    # Prebuilt x86_64 Rust binaries from GitHub releases, so flag the provenance.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
