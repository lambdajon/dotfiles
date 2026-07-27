{
  disks ? [
    "/dev/nvme0n1"
  ],
  ...
}:
let
  commonMountOptions = [
    "noatime"
    "compress=zstd:1"
    "discard=async"
    "space_cache=v2"
  ];
in
{
  disko.devices = {
    disk = {
      main = {
        device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1000M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            SWAP = {
              size = "16G";
              content = {
                type = "swap";
                discardPolicy = "pages";
              };
            };
            ROOT = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = commonMountOptions ++ [ "subvol=@" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = commonMountOptions ++ [ "subvol=@home" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = commonMountOptions ++ [ "subvol=@nix" "nodev" ];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = commonMountOptions ++ [ "subvol=@log" "nodev" "nosuid" ];
                  };
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = commonMountOptions ++ [ "subvol=@snapshots" "nodev" "nosuid" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
