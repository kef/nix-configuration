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

  # TODO Since there is a home-manager package in nixpkgs, could pull from there?
  inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";
    ref = "master";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ attrs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = false;
          home-manager.users.root = import ./home.nix;
          home-manager.users.kef = import ./home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix.
        }
      ];

      # TODO Let 'nixos-version --json' know the Git revision of this flake.
      #      Maybe goes in configuration.nix.
      #system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
    };
  };
}
