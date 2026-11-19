{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,

  # Direct ELF dependencies
  libgcc,
  libxkbcommon,
  libxcb,
  libxau,
  libxdmcp,

  # Loaded at run time (Vulkan / windowing / the game it launches)
  vulkan-loader,
  libglvnd,
  mesa,
  wayland,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  libxext,
  libxfixes,
  libxrender,
  libxinerama,
  libxxf86vm,
  alsa-lib,
  udev,
  dbus,
  fontconfig,
  freetype,
  xdg-utils,
}:

# =============================================================================
# Horizon launcher – installs and plays Horizon, Minecraft: Java Edition 26.3
# rewritten in Rust. Upstream: https://playhorizon.dev
#
# The launcher is the supported way in: it downloads a release (v0.2.97 and
# nightlies), prepares the resources from your own Minecraft install, signs in
# with the Microsoft account that owns the game, updates versions and hosts a
# server. It also ships the mod tooling (native mods, its own Rust toolchain),
# so nothing else is needed for development.
#
# The launcher keeps everything it downloads in
#   ~/.local/share/horizon-launcher
# and never writes into the Nix store.
# =============================================================================

stdenv.mkDerivation (finalAttrs: {
  pname = "horizon-launcher";
  version = "0.2.79";

  src = fetchurl {
    url = "https://github.com/horizon-rust/horizon/releases/download/launcher%40${finalAttrs.version}/horizon-launcher-linux-x86_64.tar.gz";
    hash = "sha256-ypQjXvyvMMHhyNxs0yW8ZmBLBgqpc3XPYzrnZAgkDvU=";
  };

  # The archive contains the bare `horizon-launcher` binary.
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];

  buildInputs = [
    libgcc
    libxkbcommon
    libxcb
    libxau
    libxdmcp
  ];

  runtimeLibs = [
    vulkan-loader
    libglvnd
    mesa
    wayland
    libx11
    libxcursor
    libxrandr
    libxi
    libxext
    libxfixes
    libxrender
    libxinerama
    libxxf86vm
    alsa-lib
    udev
    dbus
    fontconfig
    freetype
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 horizon-launcher $out/bin/.horizon-launcher

    makeBinaryWrapper $out/bin/.horizon-launcher $out/bin/horizon-launcher \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.runtimeLibs} \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}

    runHook postInstall
  '';

  # The launcher and the game it starts dlopen Vulkan/EGL/Wayland/X11, so an
  # RPATH-only fixup is not enough; the wrapper above provides the search path.
  dontPatchELF = false;
  dontStrip = true;

  meta = with lib; {
    description = "Launcher for Horizon, Minecraft: Java Edition 26.3 rewritten in Rust";
    homepage = "https://playhorizon.dev";
    license = licenses.mit;
    mainProgram = "horizon-launcher";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
