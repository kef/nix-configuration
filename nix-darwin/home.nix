{ config, lib, pkgs, ... }:

let
  # TODO Turn this into a flake dependency.
  LS_COLORS = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    hash = "sha256-LsR7zH4N6Rf1ILb7jAZ6kqkVAeIWJeR04EtWAjVJ1sA=";
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

    #bat
    #exa
    #fd

    # TODO Look into using nix-index.
    nix-index

    # TODO Look into using direnv.
    #direnv = {
      #enable = true;
      #nix-direnv = {
        #enable = true;
        #enableFlakes = true;
      #};
    #};

    # TODO There is a programs.bash.enableLsColors in NixOS, but not nix-darwin or home-manager.
    ls-colors

  ] ++ lib.optional pkgs.stdenv.hostPlatform.isLinux file; # NixOS only. Use macOS supplied version in nix-darwin.

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

  # TODO Look into using lorri. Should this go in NixOS/nix-darwin configuration.
  #services = {
    #lorri.enable = true;
  #};

  programs.bash = {
    enable = true;

    # LESS_TERMCAP variables are set this because home-manager sessionVariables
    # values are surrounded by double quotes, which defeats the shell quoting of
    # escape characters.
    bashrcExtra = ''
      eval $(dircolors ~/.nix-profile/share/LS_COLORS)

      export LESS_TERMCAP_mb=$'\e[1;32m';
      export LESS_TERMCAP_md=$'\e[1;32m';
      export LESS_TERMCAP_me=$'\e[0m';
      export LESS_TERMCAP_se=$'\e[0m';
      export LESS_TERMCAP_so=$'\e[01;33m';
      export LESS_TERMCAP_ue=$'\e[0m';
      export LESS_TERMCAP_us=$'\e[1;4;31m';

      # TODO Phase out once all settings have been migrated to Nix.
      . ~/.oldbashrc
    '';
    shellAliases = {

      # General.
      h = "history";
      ls = "ls --color=auto -sF";
      l = "ls";
      la = "l -a";
      ll = "l -l";
      u = "cd ..";
      r = "rsync";
      pg = "ping google.com";
      vi = "vim";
      vish = "vi $(find . -type f -print | xargs grep -l '^#\!/bin/bash')";
      rg1 = "rg --max-depth 1";
      m = "ssh moon";
      n = "ssh nixos";
      p = "ssh puff";

      # Git.
      gi = "git init";
      gcl = "git clone";
      g = "git status";
      ga = "git add .";
      gl = "git log";
      gd = "git diff";
      gdc = "git diff --cached";
      gc = "git commit";
      gca = "git commit -a -m _";
      gp = "git push";
      gpom = "git push origin master";
      gpl = "git pull";
      gplom = "git pull origin master";
      gt = "git tag";
      gb = "git branch -a";
      gco = "git checkout";
      gs = "git stash";
      gsp = "git stash pop";
      gsl = "git stash list";
      gss = "git stash show";
      gsd = "git stash drop";
      gr = "git remote -v";
      gitrm = "git stat | grep deleted | awk '{print $3}' | xargs git rm";
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

  programs.nix-index.enable = true;
  programs.nix-index.enableBashIntegration = true;
  programs.command-not-found.enable = false;

  programs.readline.enable = true;
  programs.readline.variables = {
    show-all-if-ambiguous = "On";
  };
  programs.readline.bindings = {
    "\\ep" = "history-search-backward";
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
