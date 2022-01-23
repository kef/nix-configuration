{
  # TODO Depend on unstable branches. These are more stable than the HEAD of the master branch.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = { self, nixpkgs, ... } @ attrs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      # TODO inherit nixos-hardware? Seems to be passed automatically via attrs/specialArgs.
      modules = [ ./configuration.nix ];
    };
  };
}
