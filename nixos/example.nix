  # boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" ];
  # boot.initrd.kernelModules = [ ];
  # boot.kernelModules = [ ];
  # boot.extraModulePackages = [ ];

  # TODO Configure swap?
  # swapDevices = [ ];

  # boot.loader.raspberryPi = {
  #   enable = true;
  #   version = 4;
  # };

  # networking.hostName = "nixos"; # Define your hostname. The default is "nixos".
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # TODO What unfree packages are there? Or should nixpkgs -> pkgs?
  # nixpkgs.config = {
  #   allowUnfree = true;
  # };

#  programs.git = {
    # might not work on stdenv.isDarwin
    #extraConfig = {
      #credential.helper = "${
          #pkgs.git.override { withLibsecret = true; }
        #}/bin/git-credential-libsecret";
    #};
#  };
