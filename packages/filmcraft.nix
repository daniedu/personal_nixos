{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  makeWrapper,
  alsa-lib,
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
# RUNTIME DEPS – why THIS one is the odd one out
# -----------------------------------------------------------------------------
# filmcraft is the only app in the suite with a hard DT_NEEDED beyond libc:
#
#   $ ldd usr/bin/filmcraft
#     libasound.so.2 => …        <-- the extra one
#     libgcc_s.so.1  => …
#     libm.so.6      => …
#     libc.so.6      => …
#
# It links ALSA directly (the scopes / program-monitor audio path), so unlike its
# three siblings it cannot ship as a bare unwrapped binary: an AppImage built on
# Ubuntu expects libasound.so.2 somewhere on the loader path, and inside the Nix
# store there is no such path unless we create one.
#
# It resolves today only because something outside this package put a
# libasound.so.2 symlink in /usr/lib. That is an accident of the current system
# closure, not a guarantee, so postFixup wraps the GUI binary and prefixes
# LD_LIBRARY_PATH with alsa-lib's own lib dir. Explicit > hoping.
#
# filmcraft-cli has no alsa dependency, so it stays unwrapped and usable from
# scripts without any of this.
#
# Everything else is dlopen()ed at run time and already reachable:
#   libX11.so.6, libXcursor.so.1, libXi.so.6, libX11-xcb.so.1, libxcb.so.1,
#   libwayland-client.so.0, libwayland-egl.so.1, libxkbcommon.so.0,
#   libEGL.so.1, libvulkan.so.1, libfontconfig.so.1, libfreetype.so.6
#
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
#   * No Vulkan. Mesa's Intel ANV driver needs Broadwell/Haswell (gen8+).
#   * No hardware GL either. Mesa 26 has dropped the legacy i965 driver, so
#     /run/opengl-driver/lib/dri has no i965_dri.so – only swrast_dri.so.
#
# Expect this one to be the slowest of the four. A video editor needs a real-time
# decode+composite pipeline; on lavapipe/llvmpipe over 2 Sandy Bridge cores,
# playback of anything HD will drop frames. Cut and export at small resolutions
# and short durations. That is the hardware, not this package.
#
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
in
stdenvNoCC.mkDerivation rec {
  inherit pname version src;

  # The AppImage is an opaque binary; we install from `appimageContents` instead.
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share

    # Exec=filmcraft %F is already a bare command name, so the only thing the
    # wrapper below has to add is the ALSA lib path.
    install -Dm755 ${appimageContents}/usr/bin/$pname     $out/bin/$pname
    install -Dm755 ${appimageContents}/usr/bin/$pname-cli $out/bin/$pname-cli

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

    runHook postInstall
  '';

  # libasound.so.2 has a hard DT_NEEDED in the GUI binary and there is no
  # loader path for it inside the store. Prefix ALSA's lib dir onto the wrapped
  # binary only; the CLI is untouched.
  postFixup = ''
    makeWrapper $out/bin/$pname $out/bin/$pname.orig \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ alsa-lib ]}"
    mv -f $out/bin/$pname.orig $out/bin/$pname
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
