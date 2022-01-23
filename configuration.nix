# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, nixos-hardware, ... }:

let

  kef-preston-ed25519 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFM41knX5DA3XByazAhmdYPdccWurl7ngIg6um/LoFr kef@preston.gnd";

in

{
  # Raspberry Pi 4 hardware.
  # ------------------------

  # Using the most recent revision containing a change to the raspberry-pi/4 directory.
  # TODO Review all source code in here.
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  # boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" ];
  # boot.initrd.kernelModules = [ ];
  # boot.kernelModules = [ ];
  # boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  # TODO Configure swap?
  # swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # high-resolution display
  # TODO Console terminal is 80x24 but might still be HiDPI?
  hardware.video.hidpi.enable = lib.mkDefault true;

  # System configuration.
  # ---------------------

  # boot.loader.raspberryPi = {
  #   enable = true;
  #   version = 4;
  # };

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
  system.autoUpgrade.flake = "/etc/nixos";
  system.autoUpgrade.flags = [ "--update-input" "nixpkgs" "--update-input" "nixos-hardware" "--commit-lock-file" ];

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users = {
  #   mutableUsers = false;
  #   users.jane = {
  #     isNormalUser = true;
  #     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   };
  # };

  users.users.root.openssh.authorizedKeys.keys = [ kef-preston-ed25519 ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # TODO Add useful packages.
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  #   firefox
    nixos-option
    libraspberrypi
  ];

  programs.git.enable = true;

  # TODO Fill out this configuration. See man git-config(1). Or set in home-manager instead.
  programs.git.config = {};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # TODO What unfree packages are there?
  # nixpkgs.config = {
  #   allowUnfree = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
