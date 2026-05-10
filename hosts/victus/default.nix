{
  pkgs,
  pkgs-unstable,
  lib,
  personal,
  inputs,
  ...
}:

let
  D = import ../../devtools.nix { inherit pkgs pkgs-unstable lib; };
  userExtraGroups = [
    "networkmanager"
    "wheel"
    "docker"
    "vboxusers"
    "media"
    "admins"
    "libvirtd"
  ];
in
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/boot
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/fonts.nix
    (import ../../modules/nixos/core/locale.nix { inherit (personal) timezone; })
    (import ../../modules/nixos/core/networking.nix { hostname = "victus"; })
    (import ../../modules/nixos/users/default.nix {
      inherit (personal) username;
      extraGroups = userExtraGroups;
    })

    ../../modules/nixos/desktop/common.nix
    ../../modules/nixos/desktop/xmonad

    ../../modules/nixos/services/bluetooth.nix

    # inputs.relago.nixosModules.default
  ];

  home-manager.users.${personal.username} =
    { ... }:
    {
      imports = [
        ../../modules/home/shell/zsh.nix
        ../../modules/home/shell/starship.nix
        (import ../../modules/home/editors/neovim.nix { defaultEditor = true; })
        ../../modules/home/editors/vscode.nix
        ../../modules/home/tools/misc.nix
        ../../modules/home/tools/fastfetch.nix
        (import ../../modules/home/tools/git.nix {
          name = personal.username;
          email = personal.email;
        })
      ];

      home.packages = D.rust.core;
      programs.vscode.extensions = D.rust.vscode.extensions;
      programs.vscode.userSettings = D.rust.vscode.userSettings;
      programs.neovim.extraPackages =
        D.rust.neovim.packages
        ++ (with pkgs; [
          lua-language-server
          nil
          nixfmt-rfc-style
          stylua
        ]);

      home = {
        username = personal.username;
        homeDirectory = "/home/${personal.username}";
        stateVersion = "25.11";
      };
      xdg.enable = true;
      xsession.windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ../../modules/nixos/desktop/xmonad/src/xmonad.hs;
      };
      programs.home-manager.enable = true;
    };

  system.stateVersion = "25.11";
}
