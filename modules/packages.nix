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
    xdg-utils
    gnome-disk-utility
    inputs.helium.packages.${pkgs.system}.default
    nautilus
    tela-circle-icon-theme
    bibata-cursors
    starship
  ];
}
