{
  pkgs,
  pkgs-unstable,
  lib,
  personal,
  inputs,
  config,
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
    ./hardware.nix
    # ./disk.nix

    ../../modules/nixos/boot
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/fonts.nix
    (import ../../modules/nixos/core/locale.nix { inherit (personal) timezone; })
    (import ../../modules/nixos/core/networking.nix { hostname = "vicub"; })
    (import ../../modules/nixos/users/default.nix {
      inherit (personal) username;
      extraGroups = userExtraGroups;
    })

    ../../modules/nixos/desktop/common.nix
    ../../modules/nixos/desktop/gnome.nix

    ../../modules/nixos/services/bluetooth.nix
    ../../modules/nixos/services/docker.nix

    inputs.relago.nixosModules.default
    inputs.nix-data.nixosModules.nix-data
  ];

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.nix-data = {
    enable = true;
    systemconfig = "/home/lambdajon/dotfiles/hosts/vicub/default.nix";
    flake = "/home/lambdajon/dotfiles/flake.nix";
    flakearg = "vicub";
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      libvdpau
      libva-vdpau-driver
      libva
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  services.power-profiles-daemon.enable = false;
  powerManagement.powertop.enable = false;

  services.mullvad-vpn.enable = true;

  # Printing
  services.printing.enable = true;

  # DBus broker
  services.dbus.implementation = "broker";

  # Crash dump
  boot.crashDump.enable = true;

  # Relago service
  services.relago = {
    enable = true;
    nix-config = "/home/${personal.username}/dotfiles";
  };

  # Override module defaults
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  home-manager.users.${personal.username} =
    { ... }:
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.zen-browser.homeModules.default
        ../../modules/home/browsers/firefox.nix
        ../../modules/home/shell/zsh.nix
        ../../modules/home/shell/starship.nix
        (import ../../modules/home/editors/neovim.nix { defaultEditor = true; })
        ../../modules/home/editors/vscode.nix
        ../../modules/home/tools/direnv.nix
        ../../modules/home/tools/misc.nix
        ../../modules/home/tools/fastfetch.nix
        (import ../../modules/home/tools/git.nix {
          name = personal.username;
          email = personal.email;
        })
      ];

      home.packages = D.rust.core ++ D.haskell.core;
      programs.vscode.extensions = D.rust.vscode.extensions ++ D.haskell.vscode.extensions;
      programs.vscode.userSettings = D.rust.vscode.userSettings // D.haskell.vscode.userSettings;
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
        stateVersion = "26.05";
      };
      xdg.enable = true;
      programs.home-manager.enable = true;
    };

  system.stateVersion = "26.05";
}
