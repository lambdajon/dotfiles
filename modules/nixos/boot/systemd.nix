{ ... }:
{
  config = {
    # Bootloader.
    boot = {
      consoleLogLevel = 7;
      initrd.verbose = true;
      kernelParams = [
        "systemd.log_level=debug"
        "rd.systemd.show_status=true"
      ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
