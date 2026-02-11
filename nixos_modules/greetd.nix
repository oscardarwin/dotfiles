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
  };

  services.dbus.enable = true;

}
