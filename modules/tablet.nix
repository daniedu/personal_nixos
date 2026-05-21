{ pkgs, ... }: {
  hardware.opentabletdriver.enable = true;
  environment.systemPackages = [ pkgs.opentabletdriver ];
}
