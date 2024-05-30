#!/usr/bin/env bash

nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=./machine-config.nix
./result/bin/run-nixos-vm
