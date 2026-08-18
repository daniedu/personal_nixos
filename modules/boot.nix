{ pkgs, ... }: {
  boot.loader.grub = {
    enable      = true;
    device      = "/dev/sda";
    useOSProber = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "8250.nr_uarts=0"
    "cpufreq.default_governor=performance"
  ];

  nix.settings.auto-optimise-store = true;
}
