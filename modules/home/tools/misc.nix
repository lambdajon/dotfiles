{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wget
    curl
    unzip
    zip
    jq
    yq-go
    htop
    btop
    tree
    tmux
    nix-tree
    deadnix
    statix
    nixpkgs-fmt
  ];
}
