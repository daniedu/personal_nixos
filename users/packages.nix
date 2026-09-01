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
    # kson-rs # DISABLED 2026-08: commented to avoid rebuild (keep packages/kson-rs.nix, use `nix build .#kson-rs`)

    # === Gaming (SDOJ) ===
    # sdoj-recomp # DISABLED 2026-08: commented to avoid rebuild (keep packages/sdoj-recomp.nix, use `nix build .#sdoj-recomp`)

    # === Wallpaper ===
    awww
    mpvpaper

    # === Misc ===
    obs-studio
  ];
}
