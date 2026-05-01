{ pkgs, caelestia-shell, ... }: {

  imports = [
    caelestia-shell.homeManagerModules.default
  ];

  home.username = "work";
  home.homeDirectory = "/home/work";
  home.stateVersion = "25.11";

  programs.caelestia = {
    enable = true;
    cli.enable = true; # Necessary for the wallpaper and IPC commands
    settings = {
      # Caelestia will look here for wallpapers automatically
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      bar.status.showBattery = true;
    };
  };

  # This is the Home Manager way to configure Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      "$mod" = "SUPER";

      "exec-once" = [
        "caelestia"
      ];

      bind = [
        "$mod, T, exec, kitty"
        "$mod, M, exit,"
        # Toggle the launcher (native Caelestia command)
        "$mod, D, exec, caelestia shell drawers toggle launcher"
        # Optional: Toggle the dashboard/control center
        "$mod, N, exec, caelestia shell drawers toggle dashboard"
      ];

      # Basic Catppuccin-style look
      general = {
        gaps_in = 5;
        gaps_out = 10;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        border_size = 2;
      };

      decoration = {
      drop_shadow = false;
        rounding = 10;
        blur.enabled = true;
      };
    };
  };

  home.packages = with pkgs; [
    kitty
    vscode-fhs
    papirus-icon-theme
    libnotify

    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
  ];

  fonts.fontconfig.enable = true;
}
