#!/usr/bin/env bash

dir=$(dirname "$0")

# TODO Currently doesn't work.
home-manager news --flake  "${dir}"
