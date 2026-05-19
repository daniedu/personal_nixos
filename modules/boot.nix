{ pkgs, ... }: {
  boot.loader.grub = {
    enable      = true;
    device      = "/dev/sda";
    useOSProber = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  systemd.user.services.xdg-desktop-portal = {
  Service = {
    Environment = [
      "NIX_XDG_DESKTOP_PORTAL_DIR=/run/current-system/sw/share/xdg-desktop-portal/portals"
    ];
  };
}; 
}
