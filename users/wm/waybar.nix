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
        modules-left = [ ];
        modules-center = [
          "ext/workspaces"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "clock"
          "tray"
        ];
        modules-right = [ ];

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

        "clock" = {
          tooltip-format = "{calendar}";
          format-alt = "{:%a %d %b  %H:%M}";
          format = "{:%H:%M}";
          interval = 60;
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

      #ext-workspaces {
        margin: 4px 8px;
        padding: 0 6px;
        border-radius: 10px;
        background: #${base00};
      }

      #ext-workspaces button {
        color: #${base04};
        padding: 0 6px;
        border-radius: 6px;
      }

      #ext-workspaces button.active {
        color: #${base0D};
      }

      #ext-workspaces button.urgent {
        color: #${base08};
      }

      #ext-workspaces button:hover {
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
      #network {
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

      #clock {
        margin: 4px 5px;
        padding: 6px 12px;
        border-radius: 20px;
        background: #${base00};
        color: #${base0C};
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