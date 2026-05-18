{ pkgs, inputs, lib, config, ... }: {
  imports = [
    inputs.vicinae.homeManagerModules.default
    ./shell/fish.nix
    ./shell/starship.nix
    ./shell/zoxide.nix
    ./shell/tmux.nix

    ./text/kitty.nix
    ./text/nixvim.nix
    ./text/vscode.nix
    
    ./wm/hyprland.nix
    # ./wm/waybar.nix
    # ./wm/noctalia.nix
    ./services/vicinae.nix
    ./services/wlr-which-key.nix
    
    ./launchers/opencode.nix
    
    ./programs/direnv.nix

    ./packages.nix
  ];

  home.username    = "dan";
  home.homeDirectory = "/home/work";
  home.stateVersion  = "25.11";

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  fonts.fontconfig.enable = true;

  xdg.userDirs = {
    enable     = true;
    createDirectories = true;
  };
}
