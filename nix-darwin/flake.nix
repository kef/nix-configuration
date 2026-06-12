{
  description = "nix-darwin system flake";

  # The unstable branch is more stable than the HEAD of the master branch, since it has passed
  # a set of CI tests on Hydra.
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    nix-darwin = {
      type = "github";
      owner = "LnL7";
      repo = "nix-darwin";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ls-colors = {
      type = "github";
      owner = "trapd00r";
      repo = "LS_COLORS";
      ref = "master";
      flake = false;
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ls-colors, nix-homebrew, homebrew-core, homebrew-cask, ... }:
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
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                # Install Homebrew under the default prefix
                enable = true;

                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                enableRosetta = true;

                # User owning the Homebrew prefix
                user = "kef";

                # Optional: Declarative tap management
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                };

                # Optional: Enable fully-declarative tap management
                #
                # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                mutableTaps = false;
              };
            }
            # Optional: Align homebrew taps config with nix-homebrew
            ({config, ...}: {
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            })
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
        darwinConfigurations."A08758" = darwinConfiguration {
          location = "work";
          system = "aarch64-darwin";
          user = "pokeeffe";
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
