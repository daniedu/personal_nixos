{ pkgs, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable         = true;
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";

      animations.enabled = false;

      "exec-once" = [
        "waybar"
        "nm-applet --indicator"
        "blueman-applet"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          tap-to-click = true;
          drag_lock = true;
          scroll_factor = 0.5;
        };
      };

      bind = [
        "$mod, SPACE,  exec, wofi --show drun"
        "$mod, RETURN, exec, kitty"
        "$mod, Q,      killactive,"
        "$mod, M,      exit,"
        "$mod, F,      fullscreen,"
        "$mod, E,      exec, nautilus"

        "$mod, h,  movefocus, l"
        "$mod, l,  movefocus, r"
        "$mod, j,  movefocus, u"
        "$mod, k,  movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        "$mod, P, exec, wlr-which-key"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      general = {
        gaps_in  = 5;
        gaps_out = 10;
        "col.active_border"   = lib.mkForce "rgba(00000000)";
        border_size = 2;
        layout      = "dwindle";
        resize_on_border = true;
        extend_border_grab_area = 15;
        hover_icon_on_border = true;
        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size    = 3;
          passes  = 1;
        };
      };

      master.new_status = "master";

      misc = {
        disable_hyprland_logo   = true;
        force_default_wallpaper = 0;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        focus_on_activate = true;
        key_press_enables_dpms = true;
      };
    };
  };
}
