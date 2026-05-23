{ pkgs, lib, ... }:

let
  pname = "opencode-desktop";
  version = "1.15.10";

  src = pkgs.fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-x86_64.AppImage";
    sha256 = "sha256-CmBtCgCd5tGDF2BTEdigNAmyTnC3KZp8pypartsaH68=";
  };

  contents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

  opencode-desktop = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
  install -Dm444 ${pkgs.writeText "opencode.desktop" ''
    [Desktop Entry]
    Name=Opencode Desktop
    Exec=opencode-desktop %U
    Icon=opencode-desktop
    Type=Application
    Categories=Development;
  ''} $out/share/applications/opencode.desktop

  install -Dm444 ${contents}/opencode.png \
    $out/share/icons/hicolor/512x512/apps/opencode-desktop.png
'';
  };

in {
  home.packages = [
    opencode-desktop
  ];
}