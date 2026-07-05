#!/usr/bin/env just --working-directory ./ --justfile

default:
  @just --list

format:
    nix fmt --pretty .

eval-victus:
  nix eval .#nixosConfigurations.victus.config.system.build.toplevel.drvPath --show-trace

eval-tower:
  nix eval .#nixosConfigurations.tower.config.system.build.toplevel.drvPath --show-trace

eval-vicub:
  nix eval .#nixosConfigurations.vicub.config.system.build.toplevel.drvPath --show-trace

check:
  nix flake check

eval: eval-victus

xmonad-regen:
  nix run nixpkgs#cabal2nix -- modules/nixos/desktop/xmonad > modules/nixos/desktop/xmonad/xmonad-config.nix

xmonad-build:
  nix shell --impure \
    --expr 'let p = (builtins.getFlake "path:{{justfile_directory()}}").inputs.nixpkgs.legacyPackages.${builtins.currentSystem}; in p.haskellPackages.ghcWithPackages (hp: [hp.xmonad hp.xmonad-contrib])' \
    --command ghc -fno-code modules/nixos/desktop/xmonad/src/xmonad.hs

switch-victus:
  sudo nixos-rebuild switch --flake .#victus

switch-tower:
  sudo nixos-rebuild switch --flake .#tower

switch-vicub:
  sudo nixos-rebuild switch --flake .#vicub

disk-victus:
  sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount ./hosts/victus/disk.nix

disk-tower:
  sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount ./hosts/tower/disk.nix

disk-vicub:
  sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount ./hosts/vicub/disk.nix

mount-victus:
  sudo nix run github:nix-community/disko/latest -- --mode mount ./hosts/victus/disk.nix

mount-tower:
  sudo nix run github:nix-community/disko/latest -- --mode mount ./hosts/tower/disk.nix

mount-vicub:
  sudo nix run github:nix-community/disko/latest -- --mode mount ./hosts/vicub/disk.nix

install-vicub:
  sudo nix run github:nix-community/disko/latest#disko-install -- --flake .#vicub --disk main /dev/nvme0n1