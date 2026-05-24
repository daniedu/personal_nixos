{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    file-roller
    unzip
    p7zip
    unrar
    blueman
    system-config-printer
    networkmanagerapplet
    vim
    git
    wget
    btop
    glib
    xdg-utils
    gnome-disk-utility
    inputs.helium.packages.${pkgs.system}.default
    nautilus
    bibata-cursors
    starship
    qt6.qtdeclarative
    aseprite
  ];
}
