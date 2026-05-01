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
        home-manager.nixosModules.home-manager
        {
        # Enable Hyprland at the system level
          programs.hyprland.enable = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
