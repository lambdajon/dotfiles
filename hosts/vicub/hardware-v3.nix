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
      systemd.enable = true;
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

  services.thermald.enable = true;

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.page-cluster" = 0;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  nix.settings = {
    system-features = [
      "gccarch-x86-64-v3"
      "gccarch-x86-64-v2"
      "gccarch-x86-64"
    ];
    max-jobs = 4;
    cores = 4;
  };

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "16G";
  };

  nixpkgs.localSystem = {
    gcc.arch = "x86-64-v3";
    gcc.tune = "generic";
    system = "x86_64-linux";
  };

  nixpkgs.overlays = [
    (_: prev: {
      llvmPackages_21 = prev.llvmPackages_21 // {
        llvm = prev.llvmPackages_21.llvm.overrideAttrs (_: { doCheck = false; });
      };
    })
  ];
}
