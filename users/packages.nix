{ pkgs, ... }: {
  home.packages = with pkgs; [
    # === Fonts ===
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove

    # === Screenshot & Clipboard ===
    hyprshot
    grim
    slurp
    wl-clipboard

    # === Productivity ===
    onlyoffice-desktopeditors
    hunspell
    hunspellDicts.en_US
    hunspellDicts.es_CO

    # === Audio ===
    pavucontrol

    # === System Tools ===
    btop
    ripgrep
    fd
    tree
    fastfetch

    # === Notifications & Media ===
    swaynotificationcenter
    playerctl

    # === Development ===
    nil
    lazygit

    # === Odin Development ===
    odin

    # === Gaming ===
    steam-run
    osu-lazer

    # === Art ===
    aseprite
    lmms
    pixieditor

    # === Misc ===
    wlr-which-key
    awww
    rustdesk-flutter
  ];
}
