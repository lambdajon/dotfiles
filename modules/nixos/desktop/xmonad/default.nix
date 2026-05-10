{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    windowManager.xmonad.enable = true;
  };

  services.displayManager.sddm.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    firefox
    rofi
    dunst
    feh
    scrot
    xclip
    picom
    xbindkeys
  ];
}
