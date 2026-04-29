{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    grub = {
      efiSupport = true;
      device = "nodev";
    };
  };
}
