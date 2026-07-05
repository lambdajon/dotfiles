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
      # zswap: compressed RAM cache in front of NVMe swap
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"  # denser packing than zbud
      "zswap.max_pool_percent=25"
    ];
    extraModulePackages = [ ];
    initrd = {
      kernelModules = [ "nvme" "btrfs" ];
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
    };
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
  '';

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
  };

  zramSwap.enable = false;

  boot.kernel.sysctl = {
    "vm.swappiness" = 60;
    "vm.page-cluster" = 2;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
