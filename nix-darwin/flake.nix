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
          specialArgs = {
            inherit nixpkgs;
            inherit user;
          };
          modules = [
            ./darwin-configuration-${location}.nix
            home-manager.darwinModules.home-manager {
              home-manager.extraSpecialArgs = {
                inherit ls-colors;
                inherit user;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.users.${user} = import ./home-manager/${location}.nix;
            }
            nix-homebrew.darwinModules.nix-homebrew {
              nix-homebrew = import ./nix-homebrew/homebrew-configuration.nix {
                inherit system;
                inherit homebrew-core;
                inherit homebrew-cask;
                inherit user;
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

# Work laptop configurations are no longer being maintained.
#
#        darwinConfigurations."A08758" = darwinConfiguration {
#          location = "work";
#          system = "aarch64-darwin";
#          user = "pokeeffe";
#        };
#        darwinConfigurations."A05392" = darwinConfiguration {
#          location = "work";
#          system = "x86_64-darwin";
#          user = "pokeeffe";
#        };

        # TODO Don't assume shave in these attributes as we have multiple machines.

        # TODO Making the entirety of Nixpkgs part of an output seems inadvisable. What do others do?
        # TODO When uncommented, nix flake show/check commands process a lot of packages and then fail with:
#        error:
#               … while calling the 'throw' builtin
#                 at «github:NixOS/nixpkgs/b5aa0fb»/pkgs/top-level/all-packages.nix:160:36:
#                  159|   ### Evaluating the entire Nixpkgs naively will likely fail, make failure fast
#                  160|   AAAAAASomeThingsFailToEvaluate = throw ''
#                     |                                    ^
#                  161|     This pseudo-package is likely not the only part of Nixpkgs that fails to evaluate.
#
#               error: This pseudo-package is likely not the only part of Nixpkgs that fails to evaluate.
#               You should not evaluate entire Nixpkgs without measures to handle failing packages.
        # Expose the package set, including overlays, for convenience.
#        packages."aarch64-darwin" = self.darwinConfigurations."shave".pkgs;

        # TODO Attempt to get home-manager news command to work. See error in news.sh.
        # TODO However, uncommenting fails nix flake show/check with:
#        error:
#               … while evaluating an attribute for caching
#
#               error: attribute 'activationPackage' missing
#               at «builtin-flake-schemas»/flake.nix:358:30:
#                  357|               derivationAttrPath = [ "activationPackage" ];
#                  358|               forSystems = [ this.activationPackage.system ];
#                     |                              ^
#                  359|             }) output
#        homeConfigurations = self.darwinConfigurations."shave".config.home-manager.users;
#        homeConfigurations = self.darwinConfigurations."shave".config.home-manager.users.kef.home;

        homeConfigurations."kef".config.news.json.output = self.darwinConfigurations.shave.config.home-manager.users.kef.news.json.output;
        homeConfigurations."kef".activationPackage = self.darwinConfigurations.shave.config.home-manager.users.kef.home.activationPackage;
      };
}
