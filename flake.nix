{
  description = "Multi-User System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.quickshell.follows = "quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, caelestia-shell, mango, ... }@inputs: {
    nixosConfigurations.dan = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs caelestia-shell; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
         home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # This passes your flake inputs to work.nix and lab.nix
            extraSpecialArgs = { inherit inputs caelestia-shell mango; };
            users = {
              work = import ./users/work.nix;
              lab = import ./users/lab.nix;
              # gaming = import ./users/gaming.nix;
            };
          };
        }
      ];
    };
  };
}
