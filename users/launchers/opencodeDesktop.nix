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
      # desktop file
      install -Dm444 \
        ${contents}/opencode-desktop.desktop \
        $out/share/applications/opencode-desktop.desktop

      # icon
      install -Dm444 \
        ${contents}/opencode-desktop.png \
        $out/share/icons/hicolor/512x512/apps/opencode-desktop.png

      # fix launcher
      substituteInPlace \
        $out/share/applications/opencode-desktop.desktop \
        --replace-fail 'Exec=AppRun %U' 'Exec=opencode-desktop %U'
    '';
  };

in {
  home.packages = [
    opencode-desktop
  ];
}