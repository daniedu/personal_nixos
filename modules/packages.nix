{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    # === Core CLI ===
    vim
    git
    wget
    glib
    xdg-utils
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
    power-profiles-daemon

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
    localsend
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
