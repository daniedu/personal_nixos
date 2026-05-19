{ pkgs, ... }: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
   
    gvfs 
    gvfs-mtp
    
    hyprshot
    grim
    slurp
    wl-clipboard

    onlyoffice-desktopeditors
    hunspell
    hunspellDicts.en_US
    hunspellDicts.es_CO

    pavucontrol
    btop
    ripgrep
    fd
    tree

    swaynotificationcenter
    playerctl

    nil
    lazygit

    wlr-which-key
    steam-run
    fastfetch
    awww
    gcalcli
  ];
}
