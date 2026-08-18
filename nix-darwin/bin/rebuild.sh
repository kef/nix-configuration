#!/usr/bin/env bash

dir=$(dirname "$0")

#nix flake update --flake "${dir}"
sudo darwin-rebuild switch --flake "${dir}"
#sudo darwin-rebuild switch --flake "${dir}" --show-trace --print-build-logs --verbose
