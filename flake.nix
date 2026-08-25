{
  description = "Multi-User NixOS System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://vicinae.cachix.org"
      "https://nvf.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
    ];
  };

  outputs = { self, nixpkgs, home-manager, stylix, mangowm, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
    # Expose for `nix build .#kson-rs` / `nix build .#sdoj-recomp`
    packages.${system} = let
      kson-rs = pkgs.callPackage ./packages/kson-rs.nix { };
      sdoj-recomp = pkgs.callPackage ./packages/sdoj-recomp.nix { };
    in {
      inherit kson-rs sdoj-recomp;
      default = kson-rs;
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        nixpkgs-fmt
        statix
        deadnix
      ];
    };

    nixosConfigurations.dan = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        inputs.mangowm.nixosModules.mango
        stylix.nixosModules.stylix
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs    = true;
            useUserPackages  = true;
            extraSpecialArgs = { inherit inputs; };
            users.dan = import ./users/dan.nix;
          };
        }
        # Allow unfree for sdoj-recomp (requires dump, SDK BSD-3 but package unfree)
        ({ ... }: { nixpkgs.config.allowUnfree = true; })
        # Overlay for openldap to skip tests and save time
        ({ ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              openldap = prev.openldap.overrideAttrs (old: {
                doCheck = false;
              });
            })
            # Self-packaged apps (pinned manually)
            (final: prev: {
              nuclear = final.callPackage ./packages/nuclear.nix { };
              kson-rs = final.callPackage ./packages/kson-rs.nix { };
              sdoj-recomp = final.callPackage ./packages/sdoj-recomp.nix { };
            })
          ];
        })
      ];
    };
  };
}