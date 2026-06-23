{ pkgs, ... }: {
  programs.niri = {
    enable = true;
    settings = {
      input = {
        keyboard = {
          xkb = {
            layout = "us";
          };
        };
        touchpad = {
          natural-scroll = true;
          tap = true;
          click-method = "clickfinger";
          scroll-factor = 0.5;
        };
      };

      outputs = {
        "eDP-1" = {
          scale = 1;
        };
      };

      layout = {
        gaps = 5;
        border = {
          enable = false;
        };
      };

      spawn-at-startup = [
        { command = [ "swaynotificationcenter" ]; }
        { command = [ "nm-applet" "--indicator" ]; }
        { command = [ "blueman-applet" ]; }
        { command = [ "awww-daemon" ]; }
        { command = [ "vicinae" "server" ]; }
        { command = [ "vicinae" "set" "theme" "stylix" ]; }
      ];

      binds = {
        "Mod+Space".action.spawn = [ "vicinae" "open" ];
        "Mod+Return".action.spawn = [ "kitty" ];
        "Mod+Q".action.close-window = {};
        "Mod+F".action.toggle-fullscreen = {};

        "Mod+H".action.focus-column-left = {};
        "Mod+L".action.focus-column-right = {};
        "Mod+J".action.focus-window-down = {};
        "Mod+K".action.focus-window-up = {};

        "Mod+Shift+H".action.move-column-left = {};
        "Mod+Shift+L".action.move-column-right = {};
        "Mod+Shift+J".action.move-window-down = {};
        "Mod+Shift+K".action.move-window-up = {};

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Shift+1".action.move-window-to-workspace = 1;
        "Mod+Shift+2".action.move-window-to-workspace = 2;
        "Mod+Shift+3".action.move-window-to-workspace = 3;
        "Mod+Shift+4".action.move-window-to-workspace = 4;
        "Mod+Shift+5".action.move-window-to-workspace = 5;
        "Mod+Shift+6".action.move-window-to-workspace = 6;
        "Mod+Shift+7".action.move-window-to-workspace = 7;
        "Mod+Shift+8".action.move-window-to-workspace = 8;
        "Mod+Shift+9".action.move-window-to-workspace = 9;

        "Mod+P".action.spawn = [ "wlr-which-key" ];
      };
    };
  };
}
