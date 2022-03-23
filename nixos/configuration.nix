# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, nixos-hardware, home-manager, ... }:

let

  kef-preston-ed25519 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFM41knX5DA3XByazAhmdYPdccWurl7ngIg6um/LoFr kef@preston.gnd";
  root-preston-ed25519 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC81ne+ldCdDWWsOY5UiUQiVlwsZvWX/Cqsit7IX0qQW root@preston.gnd";

in

{
  # Raspberry Pi 4 hardware.
  # ------------------------

  imports = [
    # TODO Review all source code in here.
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # high-resolution display
  # TODO Console terminal is 80x24 but might still be HiDPI?
  hardware.video.hidpi.enable = lib.mkDefault true;

  # System configuration.
  # ---------------------

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # TODO Refer to remote git repo on puff? Might not be able to use the given flags then.
  # TODO Work out how to automatically push changes to remote git repo on puff.
  system.autoUpgrade.flake = "/root/r/work/nix-configuration/nixos";
  system.autoUpgrade.flags = [
    "--update-input" "nixpkgs"
    "--update-input" "nixos-hardware"
    "--update-input" "home-manager"
    "--commit-lock-file" ];

  nix.gc.automatic = true;

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  # TODO Add further useful packages.
  environment.systemPackages = [
    pkgs.vim
    pkgs.nixos-option
    pkgs.libraspberrypi
    home-manager.defaultPackage
  ];

  programs.git.enable = true;

  # TODO Fill out this configuration. See man git-config(1). Or set in home-manager instead.
  programs.git.config = {};

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };

  users = {
    users = {
      kef = {
        name = "kef";
        home = "/home/kef";
        group = "kef";
        isNormalUser = true;
      };
      root = {
        openssh.authorizedKeys.keys = [ kef-preston-ed25519 root-preston-ed25519 ];
      };
    };
    groups.kef = {};
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
