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
      "intel_pstate=active"
      # zswap: compressed RAM cache in front of NVMe swap
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=25"
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
    tmp = {
      useTmpfs = true;
      tmpfsSize = "16G";
    };
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.page-cluster" = 0;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  networking.useDHCP = lib.mkDefault true;


  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
  '';

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

  services.thermald.enable = true;

  nix.settings = {
    max-jobs = 4;
    cores = 4;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}