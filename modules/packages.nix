{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    # === Core CLI ===
    vim
    git
    wget
    glib
    xdg-utils
    rsync
    rclone

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

    # === Writing ===
    # NEO – distraction-free word processor for novelists (EPUB/Word/PDF export).
    # AppImage-only upstream; we drive its app.asar with nixpkgs' electron.
    neo-writer

    # === Gaming ===
    heroic

    # === Extras ===
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
