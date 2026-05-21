{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aria2
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
    nmap
    graphviz
    ffmpeg-full
    sqlite
    gnupg
  ];
}
