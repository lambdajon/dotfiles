#!/usr/bin/env just --working-directory ./ --justfile

default:
  @just --list

format:
    nix fmt --pretty .

eval-victus:
  nix eval .#nixosConfigurations.victus.config.system.build.toplevel.drvPath --show-trace

check:
  nix flake check

eval: eval-victus

xmonad-regen:
  nix run nixpkgs#cabal2nix -- modules/nixos/desktop/xmonad > modules/nixos/desktop/xmonad/xmonad-config.nix
