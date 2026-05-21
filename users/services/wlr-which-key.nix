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
          - key: "t"
            desc: "Tile Layout"
            cmd: "mmsg -s -l T"
          - key: "g"
            desc: "Grid Layout"
            cmd: "mmsg -s -l G"
          - key: "s"
            desc: "Scroll Layout"
            cmd: "mmsg -s -l S"
          - key: "f"
            desc: "Fullscreen"
            cmd: "mmsg -d fullscreen"
          - key: "v"
            desc: "Floating"
            cmd: "mmsg -s -l floating"
      # - key: "l"
      #   desc: "Layout / Window State"
        # submenu:
        #   - key: "t"
        #     desc: "Tile Layout"
        #     cmd: "if [ \"$XDG_CURRENT_DESKTOP\" = \"Hyprland\" ]; then hyprctl dispatch layoutmsg preimage; else mmsg -s -l T; fi"
        #   - key: "g"
        #     desc: "Grid Layout"
        #     cmd: "if [ \"$XDG_CURRENT_DESKTOP\" = \"Hyprland\" ]; then hyprctl dispatch togglefloating; else mmsg -s -l G; fi"
        #   - key: "s"
        #     desc: "Scroll Layout"
        #     cmd: "if [ \"$XDG_CURRENT_DESKTOP\" = \"Hyprland\" ]; then :; else mmsg -s -l S; fi"
        #   - key: "f"
        #     desc: "Fullscreen"
        #     cmd: "if [ \"$XDG_CURRENT_DESKTOP\" = \"Hyprland\" ]; then hyprctl dispatch fullscreen; else mmsg -d fullscreen; fi"
        #   - key: "v"
        #     desc: "Floating"
        #     cmd: "if [ \"$XDG_CURRENT_DESKTOP\" = \"Hyprland\" ]; then hyprctl dispatch togglefloating; else mmsg -s -l floating; fi"
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
