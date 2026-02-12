{ pkgs, config, ... }: {
  environment.systemPackages = [ pkgs.tuigreet ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --user-menu --greet-align left --cmd ${pkgs.sway}/bin/sway";
        user = "greeter";
      };
      terminal = {
        vt = 1;
      };
    };
    useTextGreeter = true;
  };

  services.dbus.enable = true;
  security.polkit.enable = true;

  users.users.greeter = {
    isSystemUser = true;
    description = "Greeter user";
    home = "/var/lib/greeter";
    createHome = true;
    group = "greeter";
    extraGroups = [ "video" "input" ];
  };

  users.groups.greeter = { };
}
