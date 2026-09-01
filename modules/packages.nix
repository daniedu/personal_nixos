{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    # === Core CLI ===
    vim
    git
    wget
    glib
    xdg-utils
    rsync

    # === Archive Tools ===
    unzip
    p7zip
    unrar

    # === Hardware & System ===
    blueman
    system-config-printer
    networkmanagerapplet
    gnome-disk-utility # Disks
    baobab # GNOME Disk Usage Analyzer – visual storage browser (like gnome tool)
    power-profiles-daemon

    # === File Manager ===
    nautilus

    # === Theming ===
    bibata-cursors
    starship

    # === Gaming ===
    heroic
    protonup-qt

    # === Extras ===
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    localsend
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
