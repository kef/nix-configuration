{
  description = "nix-darwin system flake";

  # The unstable branch is more stable than the HEAD of the master branch, since it has passed
  # a set of CI tests on Hydra.
  inputs.nixpkgs = {
    type = "github";
    owner = "NixOS";
    repo = "nixpkgs";
    ref = "nixos-unstable";
  };

  inputs.nix-darwin = {
    type = "github";
    owner = "LnL7";
    repo = "nix-darwin";
    ref = "master";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";
    ref = "master";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.ls-colors = {
    type = "github";
    owner = "trapd00r";
    repo = "LS_COLORS";
    ref = "master";
    flake = false;
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ls-colors, ... }:
    let
      darwinConfiguration = { location, system, user }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit nixpkgs; };
          modules = [
            ./darwin-configuration-${location}.nix
            home-manager.darwinModules.home-manager {
              home-manager.extraSpecialArgs = { inherit ls-colors; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.users.${user} = import ./${location}.nix;
            }
          ];
        };
    in
      {
        darwinConfigurations."shave" = darwinConfiguration {
          location = "home";
          system = "aarch64-darwin";
          user = "kef";
        };
        darwinConfigurations."preston" = darwinConfiguration {
          location = "home";
          system = "x86_64-darwin";
          user = "kef";
        };
        darwinConfigurations."A05392" = darwinConfiguration {
          location = "work";
          system = "x86_64-darwin";
          user = "pokeeffe";
        };

        # TODO Don't assume shave here now that we have multiple machines.

        # Expose the package set, including overlays, for convenience.
        packages."aarch64-darwin" = self.darwinConfigurations."shave".pkgs;

        homeConfigurations = self.darwinConfigurations."shave".config.home-manager.users;
      };
}
