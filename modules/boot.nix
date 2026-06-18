{ pkgs, ... }: {
  boot.loader.grub = {
    enable      = true;
    device      = "/dev/sda";
    useOSProber = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [ "8250.nr_uarts=0" ];

  nix.settings.auto-optimise-store = true;
  systemd.user.services.xdg-desktop-portal = {
  serviceConfig = {
    Environment = [
      "NIX_XDG_DESKTOP_PORTAL_DIR=/run/current-system/sw/share/xdg-desktop-portal/portals"
    ];
  };
}; 
}
