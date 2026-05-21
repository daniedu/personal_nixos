{ pkgs, ... }: {
  users.users.dan = {
    isNormalUser = true;
    home = "/home/work"; # Change the path here
    extraGroups  = [ "networkmanager" "wheel" "video" "render" "audio" "gamemode" "opentabletdriver" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # users.users.lab = {
  #   isNormalUser = true;
  #   extraGroups  = [ "networkmanager" "video" "render" "audio" ];
  # };
}
