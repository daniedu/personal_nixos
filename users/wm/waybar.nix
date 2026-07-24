{ pkgs, lib, config, ... }:
let
  c = config.lib.stylix.colors;
  toggle-waybar = pkgs.writeShellScriptBin "toggle-waybar" ''
    if pkill -x .waybar-wrapped 2>/dev/null; then
      :
    else
      nohup waybar &>/dev/null &
    fi
  '';
in {
  home.packages = [ toggle-waybar ];
  programs.waybar = {
    enable = lib.mkDefault true;
    package = pkgs.waybar.override { wireplumberSupport = true; };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        spacing = 0;
        margin-top = 2;
        margin-right = 10;
        margin-left = 10;
        modules-left = [ "ext/workspaces" "mpris" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "group/tray-expander"
          "group/ctl"
          "clock"
        ];

        "ext/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
            "9" = "IX";
            urgent = "!";
            default = ".";
          };
          sort-by-id = true;
          on-click = "activate";
        };

        "mpris" = {
          interval = 10;
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} {artist} {title}";
          on-click-middle = "playerctl play-pause";
          on-click = "playerctl previous";
          on-click-right = "playerctl next";
          tooltip = true;
          tooltip-format = "{status_icon} {dynamic}\nLeft Click: previous\nMid Click: Pause\nRight Click: Next";
          player-icons = {
            chromium = "";
            default = "";
            firefox = "";
            mpv = "󰐹";
            spotify = "󰎆";
            vlc = "󰕼";
          };
          status-icons = {
            paused = "";
            playing = "";
            stopped = "";
          };
          dynamic-order = ["artist" "title"];
          max-length = 40;
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 25;
          rewrite = {
            " - " = "";
            "(.*) - Chromium - chromium" = "   $1 ";
            "(.*nvim)...(.*)" = "   $2 ";
            "(.*code) - (.*)" = " 󰨞  $1 ";
            "^.*btop( .*|$)" = " 󰧨 BTOP $1 ";
            "(.*) - Spotify" = "  $1 ";
            "(.*) - kitty" = "   $1 ";
            "(.*) - fish" = "   [$1] ";
            "(.*Steam)...(.*)" = "   $1";
          };
        };

        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            "children-class" = "tray-group-item";
          };
          modules = ["custom/expand-icon" "tray"];
        };

        "custom/expand-icon" = {
          format = "";
          tooltip = false;
        };

        "tray" = {
          icon-size = 12;
          spacing = 4;
        };

        "group/ctl" = {
          orientation = "inherit";
          modules = [
            "bluetooth"
            "network"
            "pulseaudio"
            "cpu"
          ];
        };

        "bluetooth" = {
          format = "";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          format-no-controller = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "blueman-applet";
        };

        "network" = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰤮";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          on-click = "nm-applet --indicator";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          on-click = "pavucontrol";
          on-click-right = "pamixer -t";
          tooltip-format = "Playing at {volume}%";
          scroll-step = 5;
          format-muted = "";
          format-icons = {
            default = ["" " " " "];
          };
        };

        "cpu" = {
          interval = 2;
          format = "󰍛 {usage}%";
          on-click = "kitty btop";
        };

        "clock" = {
          format = " {:%I:%M %p}";
          format-alt = "{:%A  %e %B}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
      };
    };

    style = with c; ''
      * {
        color: #${c.base05};
        border: none;
        border-radius: 25;
        min-height: 0;
        font-family: 'JetBrainsMono Nerd Font';
        font-size: 12px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      window#waybar {
        background: #${c.base00};
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.empty #window {
        background: transparent;
        background-color: transparent;
        border: none;
        border-radius: 0;
        color: transparent;
        padding: 0;
        margin: 0;
      }
      #waybar.empty .modules-center {
        opacity: 0;
      }

      #ext-workspaces {
          padding: 0px 5px;
          margin: 3.5 3.5px;
          border-radius: 16px;
          background: #${c.base01};
          opacity: 0.95;
      }

      #ext-workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
        color: #${c.base05};
      }

      #ext-workspaces button.active {
        color: #${c.base0D};
      }

      #ext-workspaces button.empty {
        opacity: 0.5;
      }

      #ext-workspaces button.urgent {
        color: #${c.base08};
      }

      #ext-workspaces button:hover {
        background: #${c.base02};
        box-shadow: none;
        text-shadow: none;
      }

      #cpu,
      #pulseaudio {
        min-width: 12px;
        margin: 0 7.5px;
      }

      #tray {
        background: transparent;
        border-radius: 16px;
        padding: 0px 5px;
        margin: 3.5 2px;
        margin-right: 1px;
      }

      #bluetooth {
        margin-right: 8px;
      }

      #network {
        margin-right: 9px;
      }

      #custom-expand-icon {
        margin-right: 10px;
      }

      tooltip {
        background: #${c.base00};
        border: 1px solid #${c.base05};
      }
      tooltip label {
        color: #${c.base05};
      }

      .hidden {
        opacity: 0;
      }

      #clock,
      #mpris {
          font-weight: 800;
          background: #${c.base01};
          border-radius: 16px;
          padding: 0px 5px;
          margin: 3.5 3.5px;
      }

      #window {
          font-weight: 800;
          background: #${c.base01};
          border-radius: 16px;
          padding: 0px 5px;
          margin: 3.5 2px;
      }

      #group-ctl,
      #group_ctl,
      #ctl {
          font-weight: 800;
          background: #${c.base01};
          border-radius: 16px;
          padding: 0px 5px;
          margin: 3.5 2px;
      }
    '';
  };
}