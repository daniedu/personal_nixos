{ pkgs, inputs, lib, config, ... }: {
  imports = [
    inputs.mangowm.hmModules.mango
    inputs.nixvim.homeModules.nixvim
    inputs.vicinae.homeManagerModules.default
    ./shell/fish.nix
    ./shell/starship.nix
    ./shell/zoxide.nix
    ./shell/tmux.nix

    ./text/kitty.nix
    ./text/nixvim.nix
    ./text/vscode.nix
    # ./text/zed.nix (disabled — no Vulkan support)
    
    ./wm/hyprland.nix
    ./wm/mangowm.nix
    ./wm/labwc.nix
    ./wm/niri.nix
    # ./wm/waybar.nix
    # ./wm/noctalia.nix
    ./services/vicinae.nix
    ./services/wlr-which-key.nix
    
    ./launchers/opencode.nix
    ./launchers/opencodeDesktop.nix
    
    ./programs/direnv.nix

    ./packages.nix
  ];

  home.username    = "dan";
  home.homeDirectory = "/home/work";
  home.stateVersion  = "25.11";
  programs.retroarch = {
    enable = true;
    cores = {
      mgba.enable = true;
      snes9x.enable = true;
      fbneo.enable = true;
      fceumm.enable = true;
      melonds.enable = true;
    };
  };


  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
  
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };

  fonts.fontconfig.enable = true;

  xdg.userDirs = {
    enable     = true;
    createDirectories = true;
  };
}
