#!/usr/bin/env bash

dir=$(dirname "$0")

darwin-rebuild changelog --flake "${dir}"
