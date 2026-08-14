#!/usr/bin/env bash

dir=$(dirname "$0")

# TODO Currently doesn't work.
#error: flake 'git+file:///Users/kef/r/work/nix-configuration?dir=nix-darwin' does not provide attribute
#'packages.aarch64-darwin.homeConfigurations."kef".config.news.json.output',
#'legacyPackages.aarch64-darwin.homeConfigurations."kef".config.news.json.output'
#or 'homeConfigurations."kef".config.news.json.output'
home-manager news --flake  "${dir}"
