{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./src/xmonad.hs;
    };
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
