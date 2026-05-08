{
  networking.networkmanager.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    allowInterfaces = [ "wlp2s0" ];
    publish = {
      enable = true;
      addresses = true;
    };
  };
}
