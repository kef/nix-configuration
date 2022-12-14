{
  description = "NixOS system flake";

  # The unstable branch is more stable than the HEAD of the master branch, since it has passed
  # a set of CI tests on Hydra.
  inputs.nixpkgs = {
    type = "github";
    owner = "NixOS";
    repo = "nixpkgs";
    ref = "nixos-unstable";
  };

  inputs.nixos-hardware = {
    type = "github";
    owner = "NixOS";
    repo = "nixos-hardware";
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

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ls-colors, ... }: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit nixpkgs nixos-hardware; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = { inherit ls-colors; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = false;
          home-manager.users.root = import ./home.nix;
          home-manager.users.kef = import ./home.nix;
        }
      ];

      # TODO Let 'nixos-version --json' know the Git revision of this flake.
      #      Maybe goes in configuration.nix.
      #system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
    };

    # Expose the package set, including overlays, for convenience.
    packages."aarch64-linux" = self.nixosConfigurations."nixos".pkgs;

    homeConfigurations = self.nixosConfigurations."nixos".config.home-manager.users;
  };
}
