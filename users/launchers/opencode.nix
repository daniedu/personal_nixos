{ pkgs, ... }:
let
  opencode-version = "1.14.48";
  opencode-src = pkgs.fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${opencode-version}/opencode-linux-x64.tar.gz";
    sha256 = "10mggfk9pncvdw4b0c41cv3p9dsrxwmpw4s9wrxw3yaa0zg2aqfh";
  };
  opencode-bin = pkgs.runCommandLocal "opencode-${opencode-version}" { } ''
    mkdir -p $out/bin
    tar -xzf ${opencode-src} -C $out/bin opencode
    chmod +x $out/bin/opencode
  '';
in {
  home.file.".local/bin/opencode" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      exec ${pkgs.steam-run}/bin/steam-run ${opencode-bin}/bin/opencode "$@"
    '';
  };
}
