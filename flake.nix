{
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
  };

  inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";
    ref = "master";
  };

  outputs = { self, nixpkgs, ... } @ attrs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      # TODO inherit nixos-hardware and home-manager? Seem to be passed automatically via attrs/specialArgs.
      modules = [ ./configuration.nix ];
    };
  };
}
