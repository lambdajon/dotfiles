# Packages installed on all platforms
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wget
    curl
    unzip
    zip
    jq
    yq-go
    tree
    tmux
    nix-tree
    deadnix
    statix
  ];
}
