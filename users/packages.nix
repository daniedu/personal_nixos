{ pkgs, ... }: {
  home.packages = with pkgs; [

    # === Fonts ===
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.symbols-only
    symbola

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
    bat
    ripgrep
    fd
    tree
    fastfetch

    # === Notifications & Media ===
    swaynotificationcenter
    playerctl

    # === Development ===
    lazygit
    shellcheck
    pandoc
    statix

    # === Art&Music ===
    aseprite
    lmms

    # === Gaming (SDVX) ===
    kson-rs # provides `rusc` (game) + `kson-editor` (ignored, same derivation)

    # === Gaming (SDOJ) ===
    sdoj-recomp # `sdoj-recomp` wrapper -> ~/Games/SDOJ (see packages/sdoj-recomp.nix)

    # === Wallpaper ===
    awww
    mpvpaper

    # === Misc ===
    obs-studio
  ];
}
