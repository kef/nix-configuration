{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = { self, nixpkgs, ... } @ attrs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      #inherit nixos-hardware?
      modules = [ ./configuration.nix ];
    };
  };
}
