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
      bar.status.showBattery = false;
    };
  };

  # This is the Home Manager way to configure Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      "$mod" = "SUPER";

      # 2. Disable all animations
      animations = {
        enabled = false;
      };

      "exec-once" = [
        "caelestia"
      ];

      # 3. Stripped down Hyprland bindings
      # Most logic is now handled by the 'SPACE' trigger for which-key
      bind = [
        "$mod, SPACE, exec, wlr-which-key"
        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, V, togglefloating,"
        "$mod, F, fullscreen,"

        # Focus Movement
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        # Move active window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
      ];

      # Foundation & Aesthetics
      general = {
        gaps_in = 5;
        gaps_out = 10;
        "col.active_border" = "rgba(00000000)";
        "col.inactive_border" = "rgba(00000000)";
        border_size = 2;
        layout = "dwindle"; # Ensuring your preferred layout engine
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      master = {
        new_status = "master";
      };

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
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
