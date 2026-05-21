# Packages installed on Linux only
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pciutils
    usbutils
    lsof
    xdg-utils
    flameshot
    docker-compose
  ];
}
