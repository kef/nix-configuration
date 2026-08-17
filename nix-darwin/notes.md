# To Do

- home-manager news doesn't work
  - with flakes?
  - as a nix-darwin module?
  - both?

- merge old work laptop configuration into home laptop configuration

- darwin-option doesn't work with flakes
  - https://github.com/nix-darwin/nix-darwin/issues/277

- does home-manager option work?

- set nix-darwin homebrew options
  - nix-homebrew will manage updating homebrew itself, so set autoUpdate options to false
  - when homebrew is updated, does that update all formulae?
    - yes, but to actually upgrade a brew or cask would require onActivation.upgrade set to true or manual use of brew upgrade command
    - some casks like llamabarn are deliberately set to not upgrade as they update themselves
  - set upgrade to false and manually brew upgrade individual brews after updating flake
  - set cleanup to "check"

- nix-homebrew bash integration doesn't work
  - had to comment out old brew setup commands in ~/.oldbashrc
  - enabled by default in nix-homebrew
    - but not in nix-darwin homebrew module
  - adds commands to /etc/bashrc
  - but bash completion files not added to /opt/homebrew/etc by nix-homebrew
    - profile.d/bash_completion.sh
    - bash_completion.d/*
  - known problem with nix-homebrew

- can we incorporate the manual changes to `/etc/ssh/ssh_config.d/100-linux-builder.conf` into this configuration?
  - those changes are for `darwin.linux-builder`
  - possibly just incorporate the following example into my nix-darwin flake:
    - https://nixos.org/manual/nixpkgs/stable/#sec-darwin-builder-example-flake
    - this will set up a permanently running builder virtual machine
  - now have the Linux builder from Determine Nix instead
    - uses macOS Virtualisation framework
