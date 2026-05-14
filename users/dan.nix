{ pkgs, inputs, lib, config, ... }: {
  imports = [
    ./shell/fish.nix
    ./shell/starship.nix
    ./shell/zoxide.nix
    ./text/kitty.nix
    ./text/nixvim.nix
    ./text/vscode.nix
    ./wm/hyprland.nix
    ./wm/waybar.nix
    ./wm/noctalia.nix
    ./services/vicinae.nix
    ./services/wlr-which-key.nix
    ./launchers/opencode.nix
    ./packages.nix
  ];

  home.username    = "dan";
  home.homeDirectory = "/home/dan";
  home.stateVersion  = "25.11";

  fonts.fontconfig.enable = true;

  xdg.userDirs = {
    enable     = true;
    createDirectories = true;
  };
}
