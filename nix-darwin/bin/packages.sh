#!/usr/bin/env bash

dir=$(dirname "$0")

home-manager packages --flake  "${dir}"
