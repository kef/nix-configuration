#!/usr/bin/env bash

dir=$(dirname "$0")

#darwin-rebuild switch --flake "${dir}"
darwin-rebuild switch --flake "${dir}" --recreate-lock-file
