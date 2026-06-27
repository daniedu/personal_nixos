{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    # === Core CLI ===
    vim
    git
    wget
    btop
    glib
    xdg-utils
    gnome-software
    # === Archive Tools ===
    file-roller
    unzip
    p7zip
    unrar

    # === Hardware & System ===
    blueman
    system-config-printer
    networkmanagerapplet
    gnome-disk-utility

    # === File Manager ===
    nautilus

    # === Theming ===
    bibata-cursors
    starship

    # === Gaming ===
    heroic
    protonup-qt

    # === Window Managers (alternative sessions) ===
    labwc
    niri

    # === Extras ===
    inputs.helium.packages.${pkgs.system}.default
  ];
}
