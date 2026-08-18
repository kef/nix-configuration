{ config, lib, pkgs, ls-colors, user, ... }:

{
  imports = [
    ./common.nix
  ];

  programs.git = {
    settings = {
      user = {
        name = user;
        email = "_@_";
      };
    };
  };
}
