{ pkgs, lib, ... }:

let
  pname = "opencode-desktop";
  version = "1.15.10";

  src = pkgs.fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-x86_64.AppImage";
    sha256 = "sha256-CmBtCgCd5tGDF2BTEdigNAmyTnC3KZp8pypartsaH68=";
  };

  app = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
  };

in {
  home.packages = [ app ];

  xdg.desktopEntries.opencode-desktop = {
    name = "Opencode Desktop";
    exec = "opencode-desktop %U";
    icon = "applications-development";
    categories = [ "Development" ];
    terminal = false;
  };
}