{ lib, appimageTools, fetchurl }:
let
  pname = "nuclear";
  version = "1.45.1";

  src = fetchurl {
    url = "https://github.com/nukeop/nuclear/releases/download/player%401.45.1/Nuclear_${version}_amd64.AppImage";
    sha256 = "fdMh2PS7CJ+nnNL9QMaU5HBSnBPhZJlOMXW9IQ4lBp0=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/Nuclear.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/Nuclear.desktop \
      --replace-fail 'Exec=nuclear-music-player' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Streaming music player that finds free music for you";
    homepage = "https://nuclear.js.org/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "nuclear";
  };
}
