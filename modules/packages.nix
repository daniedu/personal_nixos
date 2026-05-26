{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    # Archive Tools
    file-roller
    unzip
    p7zip
    unrar

    # Hardware & System
    blueman
    system-config-printer
    networkmanagerapplet
    gnome-disk-utility

    # Core CLI
    vim
    git
    wget
    btop
    glib
    xdg-utils

    # File Manager
    nautilus

    # Theming
    bibata-cursors

    # Shell
    starship

    # Creative
    aseprite
    lmms

    # Gaming
    lutris
    heroic
    protonup-qt

    # Extras
    qt6.qtdeclarative
    inputs.helium.packages.${pkgs.system}.default
  ];
}
