{
  description = "Multi-User System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Official Jovian-NixOS for SteamOS features
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    # MangoWM for the Work user
    mango.url = "github:mangowm/mango";
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = { self, nixpkgs, home-manager, jovian, mango, ... }@inputs: {
    nixosConfigurations.dan = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        jovian.nixosModules.default
        # Corrected Mango module override
        ({ pkgs, ... }: {
          imports = [ mango.nixosModules.mango ];
          programs.mango.package = mango.packages.${pkgs.stdenv.hostPlatform.system}.mango.override {
            libxcb-wm = pkgs.xorg.libxcbwm;
          };
        })
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
