{ pkgs, lib, config, ... }:
let
  c = config.lib.stylix.colors;
in {
  programs.waybar = {
    enable = lib.mkDefault true;
    package = pkgs.waybar.override { wireplumberSupport = true; };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 8;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "idle_inhibitor" ];
        modules-right = [
          "pulseaudio"
          "network"
          "bluetooth"
          "clock"
          "custom/tray-arrow"
          "tray"
        ];

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

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰛨";
            deactivated = "󰛩";
          };
          tooltip-format-activated = "System Focused";
          tooltip-format-deactivated = "Normal Mode";
        };

        "pulseaudio" = {
          format = "{icon}";
          format-muted = "󰝟";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋋";
            hands-free = "󰋋";
            default = [ "󰈐" "󰈑" "󰈒" ];
          };
          on-click = "pavucontrol";
          tooltip-format = "Output: {volume}%";
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "󰍬";
          format-source-muted = "󰍭";
        };

        "network" = {
          format-wifi = "{icon}";
          format-ethernet = "󰈀";
          format-linked = "󱘖";
          format-disconnected = "󰤮";
          format-disabled = "󰤮";
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          tooltip-format-disconnected = "No Connection";
          tooltip-format-disabled = "Wi-Fi is OFF";
          tooltip-format-wifi = "󰤱  {essid} ({signalStrength}%)";
          tooltip-format-ethernet = "󰈀  {ifname} (Connected)";
          on-click = "nm-applet --indicator";
          on-click-right = "pkill nm-applet";
          on-scroll-up = "nmcli radio wifi on";
          on-scroll-down = "nmcli radio wifi off";
        };

        "bluetooth" = {
          format = "󰂯";
          format-connected = "󰂱";
          format-disabled = "󰂲";
          tooltip-format = "{controller_alias} {status}";
          on-click = "blueman-manager";
          on-click-right = "rfkill toggle bluetooth";
        };

        "clock" = {
          tooltip-format = "{calendar}";
          format-alt = "{:%a %d %b  %H:%M}";
          format = "{:%H:%M}";
          interval = 60;
        };

        "custom/tray-arrow" = {
          format = "{icon}";
          tooltip = false;
          format-icons = {
            notification = "ackbar";
            none = "󰏖";
            "dnd-notification" = "󰂠";
            "dnd-none" = "󰪓";
            "inhibited-notification" = "󰂛";
            "inhibited-none" = "󰪑";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
          show-passive-items = true;
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
        background: transparent;
      }

      #workspaces {
        margin: 4px 8px;
        padding: 0 6px;
        border-radius: 10px;
        background: #${base00};
      }

      #workspaces button {
        color: #${base04};
        padding: 0 6px;
        border-radius: 6px;
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

      #idle_inhibitor {
        margin: 4px 5px;
        padding: 6px 12px;
        border-radius: 20px;
        background: #${base00};
        color: #${base05};
      }

      #pulseaudio,
      #network,
      #bluetooth {
        margin: 4px 5px;
        padding: 6px 10px;
        border-radius: 20px;
        background: #${base00};
      }

      #pulseaudio {
        color: #${base0E};
      }

      #network {
        color: #${base0B};
      }

      #bluetooth {
        color: #${base0C};
      }

      #clock {
        margin: 4px 5px;
        padding: 6px 12px;
        border-radius: 20px;
        background: #${base00};
        color: #${base0C};
      }

      #custom-tray-arrow {
        margin: 4px 5px;
        padding: 6px 10px;
        border-radius: 20px;
        background: #${base00};
        color: #${base0D};
      }

      #tray {
        margin: 4px 5px;
        padding: 6px 8px;
        border-radius: 20px;
        background: #${base00};
      }

      #tray > .passive,
      #tray > .active,
      #tray > .needs-attention {
        -gtk-icon-effect: none;
      }
    '';
  };
}