{ ... }: {
  networking.hostName = "dan";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    21114
    21115
    21116
    21117
    21118
    21119
  ];
  networking.firewall.allowedUDPPorts = [ 21116 ];
}
