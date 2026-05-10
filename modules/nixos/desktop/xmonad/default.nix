{ pkgs, lib, ... }:
let
  xmonadPkg = pkgs.haskellPackages.callPackage ./xmonad-config.nix { };
in
{
  services.xserver = {
    enable = true;
    windowManager.session = lib.singleton {
      name = "xmonad";
      start = ''
        export PATH="${xmonadPkg}/bin:$PATH"
        ${xmonadPkg}/bin/xmonad &
        waitPID=$!
      '';
    };
  };

  services.displayManager.sddm.enable = true;

  environment.systemPackages = with pkgs; [
    xmonadPkg
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
