#!/usr/bin/env bash

dir=$(dirname "$0")

#nix run nix-darwin/master#darwin-rebuild -- switch --flake "${dir}"

# Install nix-darwin on a fresh Nix installation.
sudo nix build .#darwinConfigurations.shave.system
sudo ./result/sw/bin/darwin-rebuild switch --flake "${dir}"

# TODO Clean up result subdirectory.
