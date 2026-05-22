{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk.nix
  ];

  boot = {
    kernelModules = [
      "kvm-intel"
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    kernelParams = [
      "nvidia-drm.modeset=1"
    ];
    extraModulePackages = [ ];
    initrd = {
      kernelModules = [ "nvme" ];
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
    };
  };

  networking.useDHCP = lib.mkDefault true;

  hardware = {
    # Enable any other just in case
    enableAllFirmware = true;

    # CPU (Intel)
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # GPU (Intel)
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vpl-gpu-rt
      ];
    };

    # GPU (Nvidia)
    # nvidia = {
    #   modesetting.enable = true;
    #   powerManagement.enable = true;
    #   powerManagement.finegrained = false;
    #   open = false;
    #   nvidiaSettings = true;
    #   package = config.boot.kernelPackages.nvidiaPackages.latest;
    # };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

}
