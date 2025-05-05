#{ config, pkgs, nixpkgs, home-manager, ... }:
{ config, pkgs, nixpkgs, ... }:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Need to manage flake updates manually, since autoUpgrade not supported in nix-darwin.

  nix.gc.automatic = true;
  #nix.gc.user = kef; # or root?

  nix.registry.nixpkgs.flake = nixpkgs;

  nixpkgs.config = {
    allowUnfree = true;
  };

  # TODO Currently get an error due to a macOS bug in systemsetup -settimezone.
  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # TODO Any way to set default locale?

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    home-manager
  ];

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;
  programs.bash.enable = true;

  programs.bash.completion.enable = true;

  users.users.pokeeffe = {
    name = "pokeeffe";
    home = "/Users/pokeeffe";
  };

  system.defaults.dock.autohide = true;
  system.defaults.NSGlobalDomain.AppleFontSmoothing = 0;

  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
