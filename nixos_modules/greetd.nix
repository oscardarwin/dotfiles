{ pkgs, config, ... }: {
  environment.systemPackages = [ pkgs.tuigreet ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd ${pkgs.sway}/bin/sway";
        user = "oscar";
      };
    };
    useTextGreeter = true;
  };

  services.dbus.enable = true;
  security.polkit.enable = true;
}
