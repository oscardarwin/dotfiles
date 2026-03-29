{
  networking.networkmanager.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    interfaces = [ "wlp2s0" ];
    publish = {
      enable = true;
      addresses = true;
    };
  };
}
