{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    # systemd-boot.configurationLimit = 10;
    grub = {
      efiSupport = true;
      device = "nodev";
    };
  };


}
