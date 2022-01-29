{
  description = "nix-darwin system flake";

  # The unstable branch is more stable than the HEAD of the master branch, since it has passed
  # a set of CI tests on Hydra.
  inputs.nixpkgs = {
    type = "github";
    owner = "NixOS";
    repo = "nixpkgs";
    # TODO Or use nixos-unstable? Would be nice if there was a nix-darwin-unstable.
    ref = "nixpkgs-unstable";
  };

  inputs.nix-darwin = {
    type = "github";
    owner = "LnL7";
    repo = "nix-darwin";
    ref = "master";
    # TODO Do this?
    #inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";
    ref = "master";
  };

  outputs = { self, nix-darwin, nixpkgs, ... } @ attrs:
  let
    # TODO Can this be moved into darwin-configuration.nix to simplify? Probably.
    # TODO Why wasn't it necessary for NixOS?
    configuration = { pkgs, ... }: {
      nix.package = pkgs.nixFlakes;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild switch --flake .
    darwinConfigurations.preston.gnd = nix-darwin.lib.darwinSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      # TODO inherit nix-darwin and home-manager? Seem to be passed automatically via attrs/specialArgs.
      modules = [ configuration ./darwin-configuration.nix ];
    };

    # Expose the package set, including overlays, for convenience.
    #darwinPackages = self.darwinConfigurations.preston.gnd.pkgs;
  };
}
