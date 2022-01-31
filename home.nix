{ config, pkgs, ... }:

let
  LS_COLORS = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    hash = "sha256-pyn3VnWDn5y7D/cVFV4e536ofolxBypE/01aSxDlIZI=";
  };
  ls-colors = pkgs.runCommand "ls-colors" {} ''
    mkdir -p $out/bin $out/share

    # TODO Shouldn't need a different ls on NixOS.
    ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls

    # TODO Might be direct package for dircolors. Or a home-manager enable option.
    ln -s ${pkgs.coreutils}/bin/dircolors $out/bin/dircolors

    cp ${LS_COLORS}/LS_COLORS $out/share/LS_COLORS
  '';
in
{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    file
    jq
    fzf
    ripgrep
    tree
    pstree
    htop

    # TODO There is a programs.bash.enableLsColors in NixOS, but not nix-darwin or home-manager.
    ls-colors
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval $(dircolors ~/.nix-profile/share/LS_COLORS)
    '';
    shellAliases = {

      # General.
      h = "history";
      #ls = "ls --color=auto -sF";
      l = "ls";
      la = "l -a";
      ll = "l -l";
      #less = "less -R";
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

  # TODO Replicate settings on macOS.

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
