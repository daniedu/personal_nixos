{ ... }: {
  home.file.".config/wlr-which-key/config.yaml".text = ''
    font: "JetBrainsMono Nerd Font 12"
    background: "#191724d0"
    color: "#e0def4"
    border: "#ebbcba"
    separator: " ➜ "

    menu:
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
