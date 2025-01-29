Notes
-----

- can we incorporate the manual changes to `/etc/ssh/ssh_config.d/100-linux-builder.conf` into this configuration?
  - those changes are for `darwin.linux-builder`
  - possibly just incorporate the following example into my nix-darwin flake:
    - https://nixos.org/manual/nixpkgs/stable/#sec-darwin-builder-example-flake
    - this will set up a permanently running builder virtual machine
