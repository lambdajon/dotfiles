# factory: { username, extraGroups, shell }
{
  username,
  extraGroups ? [
    "wheel"
    "networkmanager"
    "audio"
    "video"
    "docker"
  ],
  shell ? null,
}:
{ pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = extraGroups;
    shell = if shell != null then shell else pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = true;
  programs.zsh.enable = true;
}
