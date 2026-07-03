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
    shellcheck
    pandoc
    statix
    nixpkgs-fmt
    # Language servers
    clang-tools            # cc +lsp (clangd)
    nodejs                 # javascript / json
    typescript             # javascript
    lua-language-server    # lua
    python3Packages.python-lsp-server  # python
    rust-analyzer          # rust +lsp
    zls                    # zig
    odin                   # odin
    php                    # php
    phpactor               # php lsp
    bash-language-server   # sh
    dart                   # dart +flutter
    yaml-language-server   # yaml

    # === Gaming ===
    steam-run
    osu-lazer

    # === Art ===
    aseprite
    lmms

    # === Misc ===
    wlr-which-key
    awww

    # === Misc ===
  ];
}
