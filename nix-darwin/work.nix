{ config, lib, pkgs, ls-colors, ... }:

let
  ls-colors-pkg = pkgs.runCommand "ls-colors-pkg" {} ''
    mkdir -p $out/bin $out/share
    ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls
    ln -s ${pkgs.coreutils}/bin/dircolors $out/bin/dircolors
    cp ${ls-colors.outPath}/LS_COLORS $out/share/LS_COLORS
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
    dos2unix
    gradle-completion

    #bat
    #exa
    #fd

    rnix-lsp
    nixpkgs-fmt

    # TODO Look into using nix-index.
    nix-index

    # TODO Look into using direnv.
    direnv
    #direnv = {
      #enable = true;
      #nix-direnv = {
        #enable = true;
        #enableFlakes = true;
      #};
    #};

    ls-colors-pkg

#    nodejs-14_x
    #yarn

  ] ++ lib.optional pkgs.stdenv.hostPlatform.isLinux file; # NixOS only. Use macOS supplied version of file in nix-darwin.

  programs.git = {
    enable = true;
    userName = "pokeeffe";
    userEmail = "paul.okeeffe@autogeneral.com.au";
    aliases = {
      changes = "diff --name-status -r";
      st = "status";
      ci = "commit";
      co = "checkout";
      di = "diff";
      dc = "diff --cached";
      aa = "add --all";
      reb = "rebase";
      br = "branch";
      up = "pull --rebase";
      pullff = "pull --ff-only";
      merge = "merge --no-ff";
      svnup = "svn fetch";
      sup = "svn fetch";
      svnci = "svn dcommit";
      sci = "svn dcommit";
      sreb = "svn rebase";
      srt = "svn rebase remotes/trunk";
      srebt = "svn rebase remotes/trunk";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
      stash-some = "stash save --patch";
      put = "push origin HEAD";
      push-all = "!for i in $(git config --list | grep -E ^remote\\..+\\.url | sed -E 's/^remote\\.(.*)\\.url=.*/\\1/'); do git push $i master; done";
      amend = "commit --amend";
      head = "!git l -1";
      h = "!git head";
      r = "!git l -20";
      ra = "!git r --all";
      ff = "merge --ff-only";
      l = "log --graph --abbrev-commit --date=relative";
      la = "!git l --all";
      div = "divergence";
      gn = "goodness";
      gnc = "goodness --cached";
      fa = "fetch --all";
      pom = "push origin master";
      uncommit = "reset --soft";
      unadd = "reset --mixed";
      undo = "reset --hard";
    };
    extraConfig = {
      apply = {
        whitespace = "nowarn";
      };
      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        ui = "always";
      };
      core = {
        editor = "vim";
        whitespace = "fix";
        autocrlf = "input";
      };
      credential = {
        helper = "osxkeychain";
      };
      diff = {
        renames = true;
      };
      diff."ruby" = {
        funcname = "^ *\\(\\(class\\|module\\|def\\) .*\\)";
      };
      format = {
        pretty = "format:%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset";
      };
      init = {
	      defaultBranch = "master";
      };
      merge = {
        summary = true;
        tool = "opendiff";
#        tool = "vimdiff";
      };
      pull = {
        default = "tracking";
        rebase = true;
      };
      push = {
        default = "tracking";
      };
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
    };
    ignores = [
      ".DS_Store"
      "workspace.xml"
      ".rakeTasks"
      ".generators"
      ".name"
      "*.iml"
      "modules.xml"
      "dataSources.ids"
      "dataSources.xml"
      "vcs.xml"
    ];
  };

  # TODO Look into using lorri. Should this go in NixOS/nix-darwin configuration.
  #services = {
    #lorri.enable = true;
  #};

  programs.bash = {
    enable = true;

    # LESS_TERMCAP variables are set here because home-manager sessionVariables
    # values are surrounded by double quotes, which defeats the shell quoting of
    # escape characters.
    bashrcExtra = ''
      unset NIX_PATH

      eval $(dircolors ~/.nix-profile/share/LS_COLORS)

      export LESS_TERMCAP_mb=$'\e[1;32m';
      export LESS_TERMCAP_md=$'\e[1;32m';
      export LESS_TERMCAP_me=$'\e[0m';
      export LESS_TERMCAP_se=$'\e[0m';
      export LESS_TERMCAP_so=$'\e[01;33m';
      export LESS_TERMCAP_ue=$'\e[0m';
      export LESS_TERMCAP_us=$'\e[1;4;31m';

      # TODO Phase out once all settings have been migrated to Nix.
      # TODO Move .bashrc to .oldbashrc on work laptop.
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
#      n = "ssh nixos"; # Clashes with the n version manager for NodeJS.
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

  # TODO Incorporate .vimrc into this configuration. Not getting picked up.
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
