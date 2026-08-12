{ config, pkgs, nixpkgs, ... }:

{
  # Turn off nix-darwin's nix management which conflicts with Determinate Nix's facilities to do the same thing.
  nix.enable = false;

  # TODO These nix.* options are incompatible with Determinate Nix which manages the Nix installation itself instead
  #      of nix-darwin.
#  nix.extraOptions = ''
#    experimental-features = nix-command flakes
#
#    # Setup for darwin.linux-builder as per https://nixos.org/manual/nixpkgs/stable/#sec-darwin-builder.
#    extra-trusted-users = kef
#    builders = ssh-ng://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=
#
#    # Not strictly necessary, but this will reduce your disk utilization.
#    builders-use-substitutes = true
#  '';

  # Need to manage flake updates manually, since autoUpgrade not supported in nix-darwin.

  #nix.gc.automatic = true;
  #nix.gc.user = kef; # or root?

  nix.registry.nixpkgs.flake = nixpkgs;

  # TODO These nix.* options are incompatible with Determinate Nix which manages the Nix installation itself instead
  #      of nix-darwin.
  #nix.distributedBuilds = true;

  #nix.buildMachines = [
  #  { hostName = "nixos"; system = "aarch64-linux"; }
  #  { hostName = "moon"; system = "x86_64-linux"; }
  #];

  nixpkgs.config = {
    allowUnfree = true;
  };

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

  # TODO Pass in user name as an argument.
  users.users.kef = {
    name = "kef";
    home = "/Users/kef";
  };

  system.primaryUser = "kef";

  system.defaults.dock.autohide = true;

  # TODO This was uncommented for my work laptop.
  #system.defaults.NSGlobalDomain.AppleFontSmoothing = 0;

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "check"; # Or "uninstall" or "zap".
      autoUpdate = false;
      upgrade = false;
    };

    global.autoUpdate = false;

    enableBashIntegration = true;

    casks = [
      "llama-app" # Self-updates.
    ];

#    masApps = {
#      Tailscale = 1475387142; # App Store URL id
#    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ ./changelog.sh
  system.stateVersion = 7;
}
