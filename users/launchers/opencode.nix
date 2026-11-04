{ pkgs, ... }:
let
  opencode-version = "2.2.5";
  opencode-src = pkgs.fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${opencode-version}/opencode-linux-x64.tar.gz";
    sha256 = "sha256-CfRDAsEP0DaRL1nIH9Gu9d9F3Qb2SRl/nfybvip5YU4=";
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
