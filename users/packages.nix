{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove

    # Screenshot & Clipboard
    hyprshot
    grim
    slurp
    wl-clipboard

    # Office
    onlyoffice-desktopeditors
    hunspell
    hunspellDicts.en_US
    hunspellDicts.es_CO

    # Audio
    pavucontrol

    # System Tools
    btop
    ripgrep
    fd
    tree

    # Notifications & Media
    swaynotificationcenter
    playerctl

    # Development
    nil
    lazygit

    # Gaming
    steam-run
    retroarch
    osu-lazer

    # System Info
    fastfetch

    # Misc
    wlr-which-key
    awww 
    pixieditor
    rustdesk-flutter
  ];
}
