{ pkgs, lib, config, ... }:
let
  c = config.lib.stylix.colors;
in {
  programs.waybar = {
    enable = lib.mkDefault false;
    package = pkgs.waybar.override { wireplumberSupport = true; };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 8;
        margin = "5 8 0 8";

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "tray" "clock" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{name}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            urgent = "!";
            default = ".";
            empty = "·";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "hyprland/window" = {
          separate-outputs = true;
          rewrite = {
            "(.*kitty.*)" = "";
            "(.*firefox.*)" = "";
            "(.*brave.*)" = "";
            "(.*chrome.*)" = "";
            "(.*Code.*)" = "";
            "(.*nautilus.*)" = "";
            "(.*discord.*)" = "ﭮ";
            "(.*spotify.*)" = "";
            "(.*obsidian.*)" = "";
            "" = "";
          };
        };

        "tray" = {
          spacing = 10;
        };

        "clock" = {
          tooltip-format = "{calendar}";
          format-alt = "{:%a %d %b  %H:%M}";
          format = "{:%H:%M}";
          interval = 60;
        };
      };
    };

    style = with c; ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: #${base00};
        border-radius: 10px;
      }

      #workspaces button {
        color: #${base04};
        padding: 0 6px;
        border-radius: 6px;
        transition: none;
      }

      #workspaces button.active {
        color: #${base0D};
      }

      #workspaces button.urgent {
        color: #${base08};
      }

      #workspaces button:hover {
        background: #${base02};
        box-shadow: none;
        text-shadow: none;
      }

      #window {
        color: #${base05};
      }

      #tray {
        padding: 0 8px;
      }

      #clock {
        color: #${base0C};
        padding: 0 8px;
      }
    '';
  };
}
