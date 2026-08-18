#!/usr/bin/env bash

dir=$(dirname "$0")

# TODO Currently doesn't work.
home-manager news --flake  "${dir}"

# TODO With no flake configuration changes:
#error: flake 'git+file:///Users/kef/r/work/nix-configuration?dir=nix-darwin' does not provide attribute 'packages.aarch64-darwin.homeConfigurations', 'defaultPackage.aarch64-darwin.homeConfigurations', 'legacyPackages.aarch64-darwin.homeConfigurations' or 'homeConfigurations'
#error: flake 'git+file:///Users/kef/r/work/nix-configuration?dir=nix-darwin' does not provide attribute 'packages.aarch64-darwin.homeConfigurations', 'defaultPackage.aarch64-darwin.homeConfigurations', 'legacyPackages.aarch64-darwin.homeConfigurations' or 'homeConfigurations'
#error: flake 'git+file:///Users/kef/r/work/nix-configuration?dir=nix-darwin' does not provide attribute 'packages.aarch64-darwin.homeConfigurations', 'defaultPackage.aarch64-darwin.homeConfigurations', 'legacyPackages.aarch64-darwin.homeConfigurations' or 'homeConfigurations'
#error: flake 'git+file:///Users/kef/r/work/nix-configuration?dir=nix-darwin' does not provide attribute 'packages.aarch64-darwin.homeConfigurations.kef.config.news.json.output', 'defaultPackage.aarch64-darwin.homeConfigurations.kef.config.news.json.output', 'legacyPackages.aarch64-darwin.homeConfigurations.kef.config.news.json.output' or 'homeConfigurations.kef.config.news.json.output'

# TODO With the attempted flake configuration change:
#error: flake 'git+file:///Users/kef/r/work/nix-configuration?dir=nix-darwin' does not provide attribute 'packages.aarch64-darwin.homeConfigurations."kef".config.news.json.output', 'legacyPackages.aarch64-darwin.homeConfigurations."kef".config.news.json.output' or 'homeConfigurations."kef".config.news.json.output'
