#{ config, pkgs, nixpkgs, home-manager, ... }:
{ config, pkgs, nixpkgs, ... }:

{
  # TODO Remove repl-flake for nix 2.20 and above.
  nix.extraOptions = ''
    experimental-features = nix-command flakes

    # Setup for darwin.linux-builder as per https://nixos.org/manual/nixpkgs/stable/#sec-darwin-builder.
    extra-trusted-users = kef
    builders = ssh-ng://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=

    # Not strictly necessary, but this will reduce your disk utilization.
    builders-use-substitutes = true
  '';

  # Need to manage flake updates manually, since autoUpgrade not supported in nix-darwin.

  nix.gc.automatic = true;
  #nix.gc.user = kef; # or root?

  nix.registry.nixpkgs.flake = nixpkgs;

  #nix.distributedBuilds = true;

  #nix.buildMachines = [
  #  { hostName = "nixos"; system = "aarch64-linux"; }
  #  { hostName = "moon"; system = "x86_64-linux"; }
  #];

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

  users.users.kef = {
    name = "kef";
    home = "/Users/kef";
  };

  system.defaults.dock.autohide = true;
  #system.defaults.NSGlobalDomain.AppleFontSmoothing = 0;

  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
