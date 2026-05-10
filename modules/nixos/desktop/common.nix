# Common desktop services — import alongside hyprland.nix or xmonad.nix
{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.dbus.enable = true;
  services.gvfs.enable = true;
  security.rtkit.enable = true;
}
