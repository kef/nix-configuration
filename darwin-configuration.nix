{ config, pkgs, ... }:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Need to manage flake updates manually, since autoUpgrade not supported in nix-darwin.

  nix.gc.automatic = true;
  #nix.gc.user = kef; # or root?

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # TODO Any way to set default locale?

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # TODO Available in both nix-darwin and home-manager. Set in which?
  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;
  programs.bash.enable = true;

  #programs.bash.enableCompletion = true;

  users.users.kef = {
    name = "kef";
    home = "/Users/kef";
  };

  system.defaults.dock.autohide = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
