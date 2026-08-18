{ config, lib, pkgs, ls-colors, user, ... }:

{
  imports = [
    ./common.nix
  ];

  programs.git = {
    settings = {
      user = {
        name = "Paul O'Keeffe";
        email = "paul.okeeffe@autogeneral.com.au";
      };
    };
  };
}
