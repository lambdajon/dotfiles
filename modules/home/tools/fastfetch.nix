{ pkgs, ... }:
{
  home.packages = [ pkgs.fastfetch ];

  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    logo = {
      source = "Lambdajon";
      padding.right = 2;
    };
    display = {
      separator = "  ";
      color.keys = "35";
      size = {
        binaryPrefix = "si";
      };
    };
    modules = [
      "title"
      "separator"
      "title"
      "separator"
      "os"
      "host"
      "kernel"
      "uptime"
      "packages"
      "shell"
      "display"
      "de"
      "wm"
      "wmtheme"
      "theme"
      "icons"
      "font"
      "cursor"
      "terminal"
      "terminalfont"
      "cpu"
      "gpu"
      "memory"
      "swap"
      "disk"
      "localip"
      "battery"
      "poweradapter"
      "locale"
      "break"
      "colors"
    ];
  };
}
