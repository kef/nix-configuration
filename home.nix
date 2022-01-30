{ config, pkgs, ... }:

let
  LS_COLORS = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    hash = "sha256-pyn3VnWDn5y7D/cVFV4e536ofolxBypE/01aSxDlIZI=";
  };
  ls-colors = pkgs.runCommand "ls-colors" {} ''
    mkdir -p $out/bin $out/share
    ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls
    ln -s ${pkgs.coreutils}/bin/dircolors $out/bin/dircolors
    cp ${LS_COLORS}/LS_COLORS $out/share/LS_COLORS
  '';
in
{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    jq
    fzf
    ripgrep
    tree
    pstree
    htop
    ls-colors
  ];

  #programs.git = {
    #enable = true;
    #userName = "Jane Doe";
    #userEmail = "jane.doe@example.org";
  #};

  # might not work on stdenv.isDarwin
  #programs.git = {
    #enable = true;
    #extraConfig = {
      #credential.helper = "${
          #pkgs.git.override { withLibsecret = true; }
        #}/bin/git-credential-libsecret";
    #};
  #};

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.oldbashrc
    '';
    shellAliases = {
      vi = "vim";
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = "colorscheme gruvbox";
    plugins = with pkgs.vimPlugins; [
      vim-nix
      gruvbox
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.enableNixpkgsReleaseCheck = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
