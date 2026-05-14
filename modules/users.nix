{ pkgs, ... }: {
  users.users.dan = {
    isNormalUser = true;
    extraGroups  = [ "networkmanager" "wheel" "video" "render" "audio" "gamemode" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # users.users.lab = {
  #   isNormalUser = true;
  #   extraGroups  = [ "networkmanager" "video" "render" "audio" ];
  # };
}
