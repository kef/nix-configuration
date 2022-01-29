{ config, pkgs, home-manager, ... }:

{
  imports = [ (import "${home-manager}/nix-darwin") ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # TODO Reinstate?
  nix.package = pkgs.nixFlakes;

  # TODO Bring in useful and applicable global settings from NixOS configuration.nix.

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;
  programs.bash.enable = true;

  users.users.kef = {
    name = "kef";
    home = "/Users/kef";
  };

  #home-manager.useUserPackages = true; # TODO Fouls up vim.

  # TODO Try removing.
  home-manager.useGlobalPkgs = true;

  home-manager.users.kef = import ./home.nix;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
