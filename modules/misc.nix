{ ... }: {
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
  };

  nixpkgs.config.allowUnfree = true;
  zramSwap.enable = true;
  services.flatpak.enable = true;
  system.stateVersion = "25.11";
}
