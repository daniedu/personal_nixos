{ pkgs, ... }: {
  home.username = "lab"; # or "lab"
  home.homeDirectory = "/home/lab";
  home.stateVersion = "25.11";
  home.packages = [ pkgs.htop ];
#   stylix.targets.kde.enable = false;
}
