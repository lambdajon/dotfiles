# Packages installed on macOS only
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mas # Mac App Store CLI
  ];
}
