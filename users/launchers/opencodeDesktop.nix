{ pkgs, lib, ... }:

let
  pname = "opencode-desktop";
  version = "1.15.10";

  src = pkgs.fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-x86_64.AppImage";
    sha256 = "sha256-B8s6H6Qmx5O+GrpFr3dHHujcDc0fwWFwRJkX6PXRYfU=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # Rename executable to a cleaner name
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    # Desktop entry
    install -Dm444 \
      ${appimageContents}/${pname}.desktop \
      $out/share/applications/${pname}.desktop

    # Icon
    install -Dm444 \
      ${appimageContents}/${pname}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png

    # Fix Exec line
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun %U' 'Exec=${pname} %U'
  '';

  meta = with lib; {
    description = "Opencode desktop app";
    homepage = "https://github.com/anomalyco/opencode";
    license = licenses.mit; # adjust if different
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}