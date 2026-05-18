{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules/stylix.nix
    ./modules/boot.nix
    ./modules/network.nix
    ./modules/locale.nix
    ./modules/graphics.nix
    ./modules/multimedia.nix
    ./modules/packages.nix
    ./modules/bluetooth.nix
    ./modules/display.nix
    ./modules/audio.nix
    ./modules/printing.nix
    ./modules/gaming.nix
    ./modules/xdg-portal.nix
    ./modules/security.nix
    ./modules/users.nix
    ./modules/misc.nix
    ./modules/mangowm.nix
  ];
}
