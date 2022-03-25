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

  # Build using: darwin-rebuild switch --flake .
  # Add --recreate-lock-file option to update all flake dependencies.
  outputs = { self, nix-darwin, home-manager, ... } @ attrs: {
    darwinConfigurations.preston.gnd = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      specialArgs = attrs;
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = false;
          home-manager.users.kef = import ./home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix.
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    packages = self.darwinConfigurations.preston.gnd.pkgs;

    homeConfigurations = self.darwinConfigurations.preston.gnd.config.home-manager.users;
  };
}
