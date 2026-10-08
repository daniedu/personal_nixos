{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
}:

# =============================================================================
# vectorcraft – VectorCraft, an open-source vector illustration app
# Upstream: https://github.com/storytold/vectorcraft   (Apache-2.0 OR MIT)
#
# Part of the "Crafting Apps" suite from ArtCraft / storytold. Siblings packaged
# the same way in this directory: photocraft.nix, filmcraft.nix, pdfcraft.nix.
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
# WHAT WE ACTUALLY TAKE FROM THE SQUASHFS (verified on v0.7.0)
# -----------------------------------------------------------------------------
#   usr/bin/vectorcraft       the GUI. `Exec=vectorcraft %F` is a bare command
#                            name, so installing to $out/bin/vectorcraft needs NO
#                            desktop rewriting (unlike neo-writer.nix, whose
#                            AppImage points Exec at AppRun).
#   usr/bin/vectorcraft-cli   headless CLI plus `serve` (JSON control channel)
#                            and `mcp` (MCP server on stdio) – the same
#                            CLI/MCP surface as the other three craft apps.
#   usr/share/icons/hicolor/ 16..512 px PNGs + a scalable SVG.
#   usr/share/metainfo/ai.storyteller.vectorcraft.metainfo.xml
#   usr/share/mime/packages/ai.storyteller.vectorcraft.xml
#
# NOT copied: `AppRun` (a hardlink of the same GUI binary) and the duplicate
# top-level `ai.storyteller.vectorcraft.{desktop,png}` / `.DirIcon` copies that
# AppImage's runtime expects at $APPDIR.
#
# -----------------------------------------------------------------------------
# RUNTIME DEPS – why this needs no wrapper at all
# -----------------------------------------------------------------------------
# `ldd` on usr/bin/vectorcraft gives exactly three NEEDED libs:
#   libgcc_s.so.1, libm.so.6, libc.so.6
# Everything else is dlopen()ed at run time, which we cannot see statically:
#   libX11.so.6, libXcursor.so.1, libXi.so.6, libX11-xcb.so.1, libxcb.so.1,
#   libwayland-client.so.0, libwayland-egl.so.1, libxkbcommon.so.0,
#   libEGL.so.1, libvulkan.so.1, libfontconfig.so.1, libfreetype.so.6
# All of those are already reachable on this system, so $out/bin/vectorcraft is
# the unwrapped upstream binary.
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
# just CPU-bound on 2 cores. Repainting bezier-heavy artboards and applying
# live effects WILL feel slow, and that is the hardware, not this package.
#
# -----------------------------------------------------------------------------
# HOW TO UPDATE (manual-hash workflow – same as packages/kson-rs.nix)
# -----------------------------------------------------------------------------
# These apps release often (v0.4.0 -> v0.7.0 on the same day). To move forward:
#
# 1. Find the newest release and its x86_64 AppImage hash:
#      curl -s https://api.github.com/repos/storytold/vectorcraft/releases/latest \
#        | jq -r '.tag_name, (.assets[] | select(.name|test("linux-x86_64.AppImage$")) | .name)'
#      curl -s https://github.com/storytold/vectorcraft/releases/download/v<NEW>/SHA256SUMS.txt \
#        | grep linux-x86_64.AppImage
#
# 2. Update `version` below. The asset name is always
#    `${pname}-${version}-linux-x86_64.AppImage` (no `v` in the filename even
#    though the tag is `v<version>`).
#
# 3. Update `hash`. Easiest is to skip SHA256SUMS.txt entirely:
#      hash = lib.fakeHash;  then  nix build .#vectorcraft
#    The mismatch error prints the exact `got: sha256-...` to paste back.
#
# 4. Re-check the squashfs layout if the table above stops matching. All four
#    craft apps shipped an identical layout at v0.4-0.7; if `installPhase` fails
#    with "No such file or directory", unpack it and look:
#      nix build --no-link --print-out-paths --impure --expr '
#        let f = builtins.getFlake (toString ./.);
#        in f.inputs.nixpkgs.legacyPackages.x86_64-linux.appimageTools.extract {
#          pname = "vectorcraft-probe"; version = "<NEW>";
#          src = f.inputs.nixpkgs.legacyPackages.x86_64-linux.fetchurl {
#            url = "..."; hash = "sha256-..."; };
#        }'
#
# 5. Verify:
#      nix build .#vectorcraft
#      ./result/bin/vectorcraft-cli --help
#      ./result/bin/vectorcraft
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
  pname = "vectorcraft";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    hash = "sha256-9pKPmt9COtChRev+OxQqldPSb1ULBSScIBIUVwH5i2A=";
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

    # Exec=vectorcraft %F is already a bare command name, so no wrapper and no
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
    description = "Open-source vector illustration app with bezier pen, shapes, gradients, appearance effects and a CLI/MCP automation interface";
    homepage = "https://github.com/storytold/vectorcraft";
    downloadPage = "https://github.com/storytold/vectorcraft/releases";
    changelog = "https://github.com/storytold/vectorcraft/releases";
    license = licenses.asl20; # dual Apache-2.0 OR MIT
    mainProgram = pname;
    platforms = platforms.linux;
    # Prebuilt x86_64 Rust binaries from GitHub releases, so flag the provenance.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
