{
  disks ? [
    "/dev/nvme0n1"
    "/dev/sda"
  ],
  ...
}:{
  disko.devices = {
    disk = {
      nvme0n1 = {
        device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            SWAP = {
              size = "36G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            ROOT = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      sda = {
        device =  builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            MEDIA = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/media";
              };
            };
          };
        };
      };
      # sdb = {
      #   device = "/dev/sdb";
      #   type = "disk";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       SERVER = {
      #         size = "100%";
      #         content = {
      #           type = "filesystem";
      #           format = "ext4";
      #           mountpoint = "/srv";
      #         };
      #       };
      #     };
      #   };
      # };

    };
  };
}
