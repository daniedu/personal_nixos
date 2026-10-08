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
  ...
}:

# =============================================================================
# pdfcraft – PdfCraft, an open-source PDF workbench
# Upstream: https://github.com/storytold/pdfcraft   (Apache-2.0 OR MIT)
#
# Part of the "Crafting Apps" suite from ArtCraft / storytold. Siblings packaged
# the same way in this directory: photocraft.nix, vectorcraft.nix, filmcraft.nix.
# Installed together behind the `artcraft.enable` toggle in modules/artcraft.nix.
#
# -----------------------------------------------------------------------------
# NAME HISTORY – if you follow the releases, this one looks confusing
# -----------------------------------------------------------------------------
# The repo was `storytold/pdfcraft` from the start, but the shipped artefacts
# were called PrintCraft up to and including v0.2.1:
#
#   v0.2.1  printcraft-0.2.1-linux-x86_64.AppImage, usr/bin/printcraft,
#           desktop app id ai.storyteller.printcraft
#   v0.4.0  pdfcraft-0.4.0-linux-x86_64.AppImage,   usr/bin/pdfcraft,
#           desktop app id ai.storyteller.pdfcraft     <-- current
#
# The rename is complete as of v0.4.0, so nothing here needs a compat alias and
# the binary, the command, the Nix attribute and the desktop entry all agree on
# `pdfcraft`. If you ever read an old blog post or issue that says PrintCraft,
# that is the same app. Do not go looking for a v0.3.x: it was skipped.
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
#      ("no Tauri, Electron or webview shells").
#
# -----------------------------------------------------------------------------
# WHAT WE ACTUALLY TAKE FROM THE SQUASHFS (verified on v0.4.0)
# -----------------------------------------------------------------------------
#   usr/bin/pdfcraft       the GUI. `Exec=pdfcraft %F` is a bare command name,
#                          so installing to $out/bin/pdfcraft needs NO desktop
#                          rewriting (unlike neo-writer.nix, whose AppImage
#                          points Exec at AppRun).
#   usr/bin/pdfcraft-cli   headless CLI: info / render / text / edit / combine /
#                          extract / split / check / tools / run, plus `serve`
#                          and `mcp` for agents.
#   usr/share/icons/hicolor/ 16..512 px PNGs + a scalable SVG.
#   usr/share/metainfo/ai.storyteller.pdfcraft.metainfo.xml
#   usr/share/mime/packages/ai.storyteller.pdfcraft.xml
#
# NOT copied: `AppRun` (a hardlink of the same GUI binary) and the duplicate
# top-level `ai.storyteller.pdfcraft.{desktop,png}` / `.DirIcon` copies.
#
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# RUNTIME DEPS – why this file patches the ELF (do not "simplify" this away)
# -----------------------------------------------------------------------------
# Upstream builds on Ubuntu and ships a generic binary. `ldd` on it shows only
# these NEEDED libs:
#     libgcc_s.so.1, libm.so.6, libc.so.6
# and the ELF interpreter is the generic /lib64/ld-linux-x86-64.so.2.
#
# Everything else is dlopen()ed at run time, which ldd cannot show:
#     libX11.so.6, libXcursor.so.1, libXi.so.6, libX11-xcb.so.1, libxcb.so.1,
#     libwayland-client.so.0, libwayland-egl.so.1, libxkbcommon.so.0,
#     libEGL.so.1, libvulkan.so.1, libfontconfig.so.1, libfreetype.so.6
#
# Note on fonts: PdfCraft renders PDFs, so its own text shaping needs
# fontconfig. That is dlopen()ed, and users/dan.nix already sets
# `fonts.fontconfig.enable` plus Nerd Fonts + Symbola in home.packages, so the
# same fonts every other app on this system uses are visible to it. No
# FONTCONFIG_FILE override needed – that is the nice part of not being a
# Flatpak.
#
# Left alone, that binary only runs on NixOS by ACCIDENT: the kernel resolves
# /lib64/ld-linux-x86-64.so.2 through /usr/lib symlinks that some other package
# in the closure happens to create, and the dlopen()s land there too. Those
# symlinks come and go with unrelated packages, so the app "works" until a
# rebuild removes them and then fails with:
#     Could not start dynamically linked executable: pdfcraft
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
# # Expect page previews, continuous scrolling and two-up read mode to lag on
# image-heavy documents. Text-only PDFs should be fine. This is the hardware,
# not this package.
# A zbus warning about org.freedesktop.DBus at startup is normal and harmless
# here (xdg-desktop-portal not up yet); the apps carry on.
# -----------------------------------------------------------------------------
# HOW TO UPDATE (manual-hash workflow – same as packages/kson-rs.nix)
# -----------------------------------------------------------------------------
# These apps release often (v0.2.1 -> v0.4.0 on the same day). To move forward:
#
# 1. Find the newest release and its x86_64 AppImage hash:
#      curl -s https://api.github.com/repos/storytold/pdfcraft/releases/latest \
#        | jq -r '.tag_name, (.assets[] | select(.name|test("linux-x86_64.AppImage$")) | .name)'
#      curl -s https://github.com/storytold/pdfcraft/releases/download/v<NEW>/SHA256SUMS.txt \
#        | grep linux-x86_64.AppImage
#
#    CHECK THE FILENAME CAREFULLY. If a future release reverts to `printcraft-*`
#    you must change `pname` and `url` together, or fetchurl will 404 on a name
#    that still resolves. Compare against the v0.2.1-era filenames above.
#
# 2. Update `version` below. The asset name is
#    `${pname}-${version}-linux-x86_64.AppImage` (no `v` in the filename even
#    though the tag is `v<version>`).
#
# 3. Update `hash`. Easiest is to skip SHA256SUMS.txt entirely:
#      hash = lib.fakeHash;  then  nix build .#pdfcraft
#    The mismatch error prints the exact `got: sha256-...` to paste back.
#
# 4. Re-check the squashfs layout if the table above stops matching. All four
#    craft apps shipped an identical layout at v0.4-0.7; if `installPhase` fails
#    with "No such file or directory", unpack it and look:
#      nix build --no-link --print-out-paths --impure --expr '
#        let f = builtins.getFlake (toString ./.);
#        in f.inputs.nixpkgs.legacyPackages.x86_64-linux.appimageTools.extract {
#          pname = "pdfcraft-probe"; version = "<NEW>";
#          src = f.inputs.nixpkgs.legacyPackages.x86_64-linux.fetchurl {
#            url = "..."; hash = "sha256-..."; };
#        }'
#
# 5. Verify:
#      nix build .#pdfcraft
#      ./result/bin/pdfcraft-cli --help
#      ./result/bin/pdfcraft
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
  pname = "pdfcraft";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/storytold/pdfcraft/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    hash = "sha256-4hzn3kmRCsyPAypLkGFB2kKzkAI4P7nvM6nYbbvsBdY=";
  };

  # Unsquashed AppImage. The AppRun/squashfs bits are discarded by installPhase.
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
  # Everything the GUI and CLI need at run time, resolved into one RPATH.
  # glibc + libgcc cover the NEEDED libs; the rest cover the dlopen()s.
  # libxkbcommon also ships libxkbcommon-x11.so.0, which these apps need on the
  # X11 fallback path.
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

    # Exec=pdfcraft %F is already a bare command name, so no wrapper and no
    # .desktop rewriting is needed here.
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
    description = "Open-source PDF workbench for reading, organizing, combining, splitting and securing PDFs, with a CLI/MCP automation interface";
    homepage = "https://github.com/storytold/pdfcraft";
    downloadPage = "https://github.com/storytold/pdfcraft/releases";
    changelog = "https://github.com/storytold/pdfcraft/releases";
    license = licenses.asl20; # dual Apache-2.0 OR MIT
    mainProgram = pname;
    platforms = platforms.linux;
    # Prebuilt x86_64 Rust binaries from GitHub releases, so flag the provenance.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
