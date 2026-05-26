{ config, lib, ... }:
let
  c = config.lib.stylix.colors.withHashtag;
in {
  home.file.".config/wlr-which-key/config.yaml".text = ''
    font: "JetBrainsMono Nerd Font 12"
    background: "${c.base01}"
    color: "#ffffff"
    border_width: 0
    border: "${c.base09}"
    padding: 16
    corner_r: 0
    separator: " - "

    menu:
      - key: "l"
        desc: "Layout / Window State"
        submenu:
          - key: "s"
            desc: "Scroll Layout"
            cmd: "hyprctl keyword general:layout scrolling"
          - key: "d"
            desc: "Dwindle Layout"
            cmd: "hyprctl keyword general:layout dwindle"
          - key: "v"
            desc: "Floating"
            cmd: "hyprctl dispatch togglefloating"
          - key: "g"
            desc: "Groups"
            submenu:
              - key: "g"
                desc: "Toggle Group"
                cmd: "hyprctl dispatch togglegroup"
              - key: "l"
                desc: "Lock Group"
                cmd: "hyprctl dispatch lockactivegroup"
              - key: "i"
                desc: "Move Into Group"
                cmd: "hyprctl dispatch moveintogroup"
              - key: "o"
                desc: "Move Out of Group"
                cmd: "hyprctl dispatch moveoutofgroup"
              - key: "c"
                desc: "Cycle Active"
                cmd: "hyprctl dispatch changegroupactive"
      - key: "s"
        desc: "Screenshot (Hyprshot)"
        submenu:
          - key: "s"
            desc: "Select Region"
            cmd: "hyprshot -m region"
          - key: "f"
            desc: "Full Screen (Monitor)"
            cmd: "hyprshot -m output"
          - key: "w"
            desc: "Active Window"
            cmd: "hyprshot -m window"
          - key: "c"
            desc: "Region to Clipboard Only"
            cmd: "hyprshot -m region --clipboard-only"
      - key: "p"
        desc: "Power"
        submenu:
          - key: "r"
            desc: "Reboot"
            cmd: "systemctl reboot"
          - key: "o"
            desc: "Power Off"
            cmd: "systemctl poweroff"
  '';
}
