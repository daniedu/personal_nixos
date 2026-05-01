{ pkgs, ... }: {
  home.username = "work";
  home.homeDirectory = "/home/work";
  home.stateVersion = "25.11";

  # This is the Home Manager way to configure Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, T, exec, kitty"
        "$mod, M, exit,"
      ];
      # Basic Catppuccin-style look
      general = {
        gaps_in = 5;
        gaps_out = 10;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      };
    };
  };

  home.packages = with pkgs; [
    kitty
    ghostty
  ];

  programs.ghostty = {
    enable = true;
  };
}
