# factory: { hostname }
{ hostname }:
{ pkgs, ... }:
{
  imports = [ ../nixos/core/nix.nix ];

  networking.hostName = hostname;
  networking.computerName = hostname;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
  ];

  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "clmv";
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
  };

  system.stateVersion = 5;
  programs.zsh.enable = true;
}
