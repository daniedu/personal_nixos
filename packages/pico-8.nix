{ lib
, stdenvNoCC
, makeBinaryWrapper
, makeDesktopItem
, patchelf
, requireFile
, unzip
, sdl2-compat
, wget
, glibc
, libgcc
, libx11
, libxcursor
, libxext
, libxinerama
, libxi
, libxrandr
, libxscrnsaver
, libxxf86vm
, libxcb
, libxau
, libxdmcp
, libxfixes
, libxrender
, libGL
, libglvnd
, alsa-lib
, libpulseaudio
, libsamplerate
, udev
, dbus
, curl
, vulkan-loader
}:

# =============================================================================
# pico-8 – the PICO-8 fantasy console (commercial, unfree)
# Upstream: https://www.lexaloffle.com/pico-8.php
#
# This is a repackaging of the official Linux 64-bit archive
# (pico-8_0.2.7_amd64.zip). It is modelled on the nixpkgs PR that is still
# open upstream (NixOS/nixpkgs#551567, "pico-8: init at 0.2.7") and on the
# standalone flake that PR's author published (codeberg.org/husjon/nix-pico-8).
#
# What the archive contains, and what this package does with it:
#   pico8                64-bit ELF, SDL2 *statically* linked in
#   pico8_dyn            64-bit ELF, links libSDL2-2.0.so.0 dynamically
#   pico8.dat            the VM itself, has to sit next to the executable
#   pico-8_manual.txt    the manual
#   license.txt          Lexaloffle's licence
#   lexaloffle-pico8.png the launcher icon
#
# -----------------------------------------------------------------------------
# WHY THE ARCHIVE IS NOT FETCHED AUTOMATICALLY
# -----------------------------------------------------------------------------
# PICO-8 is commercial software. The archive is only downloadable from the
# buyer's own Lexaloffle account, so it cannot be fetched with `fetchurl`.
# Upstream's answer is `requireFile`: the archive is expected to be in the
# Nix store already, and the build fails with instructions if it is not.
#
#   nix-prefetch-url file://$PWD/pico-8_0.2.7a6_amd64.zip
#
# That prints the hash and drops the file into the store. The hash below is
# the one upstream uses for the official 0.2.7 Linux amd64 archive (the beta
# build 0.2.7a6 hashes to the same value, only the file name differs); if
# your archive is a different build, `nix-prefetch-url` prints the one to use.
#
# Nothing proprietary ever lands in this git repository: the archive stays on
# disk / in the Nix store, the repository only holds this expression.
# -----------------------------------------------------------------------------
# HOW TO UPDATE
# -----------------------------------------------------------------------------
# 1. Buy/download the new archive from your Lexaloffle account:
#      https://www.lexaloffle.com/games.php?page=my
#    (specific versions: https://www.lexaloffle.com/games.php?page=archive)
#
# 2. Get its hash and put the archive into the store:
#      nix-prefetch-url file://$PWD/pico-8_<NEW>_amd64.zip
#
# 3. Update `version` and `hash` below. `name` is always
#    `${pname}_${version}_amd64.zip` – the store path of the archive depends
#    on that name, so it has to match the file name you downloaded.
#
# 4. Verify:
#      nix build .#pico-8
#      ./result/bin/pico8-wrapped        # a window opens (X11/XWayland)
#      nixos-rebuild switch --flake .#dan
#
# Rollback: revert `version`/`hash` in git, or set `pico8.enable = false` in
# modules/pico-8.nix and rebuild to drop PICO-8 from the system.
# -----------------------------------------------------------------------------
# DISPLAY – PICO-8 IS X11 ONLY
# -----------------------------------------------------------------------------
# Neither binary contains a single Wayland string: the SDL2 build inside
# `pico8` only has the X11 video driver, so PICO-8 needs an X server. On this
# machine the Mango session already runs Xwayland (`Xwayland :0 -rootless`),
# so PICO-8 opens its window on it. If that ever stops happening, enable
# `services.xserver.enable = true` (that is what provides Xwayland).
#
# The renderer is OpenGL through Mesa. This box is a Pentium G630 (HD
# Graphics 2000, gen6) without hardware GL, so it lands on llvmpipe: correct
# but CPU-bound. PICO-8's own canvas is 128x128, so it is cheap either way.
# -----------------------------------------------------------------------------
# SAVES AND CART DATA
# -----------------------------------------------------------------------------
# PICO-8 keeps its saves, settings and downloaded carts in
# ~/.lexaloffle/pico8/cdata – outside the Nix store, so they are writable and
# survive rebuilds. Only `pico8.dat` (the VM) is read-only in the store, and
# PICO-8 never writes to it.
# =============================================================================

let
  pname = "pico-8";
  # The archive in use is the 0.2.7 beta build 0.2.7a6 – its content hash is
  # the same one upstream publishes for 0.2.7, only the file name differs.
  version = "0.2.7a6";

  src = requireFile {
    name = "${pname}_${version}_amd64.zip";
    hash = "sha256-7fLOhUdAWFsPmIhO4J1j+auObIdy4BSKkCkntkCMnqo=";
    message = ''
      PICO-8 is commercial software, so the archive cannot be downloaded
      automatically. Get the Linux 64-bit archive from your Lexaloffle
      account (https://www.lexaloffle.com/games.php?page=my) and load it
      into the Nix store:

        nix-prefetch-url file://$PWD/${pname}_${version}_amd64.zip

      The hash of the official 0.2.7 archive is
      sha256-7fLOhUdAWFsPmIhO4J1j+auObIdy4BSKkCkntkCMnqo=
      If your archive hashes differently, update `hash` in
      packages/pico-8.nix with the value nix-prefetch-url prints.
    '';
  };

  # Every library the binaries NEED or dlopen() at run time. SDL2 is linked
  # statically into `pico8`, so it dlopens the X11/GL/audio stack itself:
  #   libX11.so.6 libXcursor.so.1 libXext.so.6 libXinerama.so.1 libXi.so.6
  #   libXrandr.so.2 libXss.so.1 libXxf86vm.so.1 libX11-xcb.so.1
  #   libGL.so.1 libEGL.so.1 libvulkan.so.1
  #   libasound.so.2 libpulse-simple.so.0 libsamplerate.so.0
  #   libudev.so.1 libdbus-1.so.3 libcurl.so.4
  # libX11-xcb.so.1 ships inside libx11, so it needs no extra entry.
  runtimeInputs = [
    glibc
    libgcc

    # X11 (SDL2's video driver)
    libx11
    libxcursor
    libxext
    libxinerama
    libxi
    libxrandr
    libxscrnsaver
    libxxf86vm
    libxcb
    libxau
    libxdmcp
    libxfixes
    libxrender

    # OpenGL / Vulkan
    libGL
    libglvnd
    vulkan-loader

    # Audio (PipeWire is the sound server here, ALSA and Pulse both land in it)
    alsa-lib
    libpulseaudio
    libsamplerate

    # Gamepads, screensaver inhibition, BBS downloads
    udev
    dbus
    curl
  ];
in
stdenvNoCC.mkDerivation rec {
  inherit pname version src;

  # PICO-8 is a closed-source binary – no compiler, no configure, no build.
  dontConfigure = true;
  dontBuild = true;

  # Do not let the fixup phase touch the binaries: it would shrink the RPATH
  # down to the libraries the ELF actually NEEDs, and PICO-8 dlopens X11, GL,
  # ALSA and friends at run time instead of linking them.
  dontPatchELF = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    patchelf
    unzip
    glibc # ldd, for the install check below
  ];

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "PICO-8";
    comment = "Fantasy console";
    icon = pname;
    exec = "pico8-wrapped";
    categories = [
      "Development"
      "Game"
    ];
    terminal = false;
  };

  unpackPhase = ''
    runHook preUnpack

    unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # The archive unpacks into a pico-8/ directory.
    if [ -d pico-8 ]; then cd pico-8; fi

    # Make both binaries Nix-native: a Nix glibc interpreter plus an RPATH
    # that covers every NEEDED and dlopen()ed library. The RPATH is what lets
    # SDL2 find X11/GL/audio at run time without a wrapper.
    for bin in pico8 pico8_dyn; do
      patchelf \
        --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 \
        --set-rpath ${lib.makeLibraryPath runtimeInputs} \
        "$bin"
    done

    # `pico8` has SDL2 built in, `pico8_dyn` wants the system SDL2 – point it
    # at nixpkgs' one.
    patchelf \
      --replace-needed libSDL2-2.0.so.0 ${sdl2-compat}/lib/libSDL2-2.0.so.0 \
      pico8_dyn

    install -Dm755 pico8     $out/bin/pico8
    install -Dm755 pico8_dyn $out/bin/pico8_dyn

    # pico8.dat is the VM itself and has to live next to the executable.
    install -Dm644 pico8.dat $out/bin/pico8.dat

    # Wrapper: Splore (the built-in BBS browser) shells out to wget to fetch
    # and unzip carts, so wget has to be on PATH.
    makeBinaryWrapper $out/bin/pico8 $out/bin/pico8-wrapped \
      --prefix PATH : ${wget}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeInputs}

    makeBinaryWrapper $out/bin/pico8_dyn $out/bin/pico8-dyn-wrapped \
      --prefix PATH : ${wget}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeInputs}

    install -Dm444 pico-8_manual.txt $out/share/doc/${pname}/manual.txt
    install -Dm444 license.txt $out/share/doc/${pname}/license/license.txt
    install -Dm444 lexaloffle-pico8.png \
      $out/share/icons/hicolor/128x128/apps/${pname}.png

    install -Dm644 "${desktopItem}/share/applications/${pname}.desktop" \
      $out/share/applications/${pname}.desktop

    runHook postInstall
  '';

  # Belt and braces: after the package is realised, prove both binaries link
  # with NOTHING from the host. A stray DT_NEEDED left unresolved would only
  # show up at run time as the generic-dynamic-executable error.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export LD_LIBRARY_PATH=""

    ldd $out/bin/pico8     > /dev/null
    ldd $out/bin/pico8_dyn > /dev/null

    test -f $out/bin/pico8.dat
    test -x $out/bin/pico8-wrapped

    runHook postInstallCheck
  '';

  # The binaries carry debug info upstream; do not touch them.
  dontStrip = true;

  meta = with lib; {
    description = "Fantasy console for making, sharing and playing tiny games and other computer programs";
    homepage = "https://pico-8.com";
    license = licenses.unfree;
    mainProgram = "pico8-wrapped";
    platforms = platforms.linux;
  };
}
