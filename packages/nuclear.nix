{ lib, appimageTools, fetchurl }:
let
  pname = "nuclear";
  version = "1.47.1";

  src = fetchurl {
    url = "https://github.com/nukeop/nuclear/releases/download/player%40${version}/Nuclear_${version}_amd64.AppImage";
    hash = "sha256-URTJmsbS6IFp4uzUJOYjN0u2BfaOnlHhhNzu/sCfxkI=";
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
