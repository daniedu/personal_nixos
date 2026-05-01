{ pkgs, ... }: {
  home.username = "gaming"; # or "lab"
  home.homeDirectory = "/home/gaming";
  home.stateVersion = "25.11";
  home.packages = [ pkgs.htop ];
}
