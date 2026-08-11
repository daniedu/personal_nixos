{ ... }: {
  networking.hostName              = "dan";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 21115 21116 21117 ];
  networking.firewall.allowedUDPPorts = [ 21116 ];
}
