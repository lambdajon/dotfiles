{ pkgs, ... }:
{
  home.packages = [ pkgs.topgrade ];

  xdg.configFile."topgrade.toml".text = ''
    [misc]
    assume_yes = false
    disable = ["emacs", "vim"]
    notify_each_step = false

    [linux]
    enable_tldr_update = true

    [git]
    repos = [
      "~/dotfiles",
    ]
  '';
}
