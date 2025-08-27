#!/usr/bin/env bash

dir=$(dirname "$0")

nix run nix-darwin/master#darwin-rebuild -- switch --flake "${dir}"
