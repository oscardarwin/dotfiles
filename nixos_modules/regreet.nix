{ pkgs, config, ... }: {
  environment.systemPackages = [ pkgs.gtkgreet pkgs.cage ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.cage}/bin/cage -s -- \
            ${pkgs.gtkgreet}/bin/gtkgreet
        '';
        user = "greeter";
      };
    };
  };

  users.users.greeter = {
    isSystemUser = true;
    description = "Greeter user";
    home = "/var/lib/greeter";
    createHome = true;
    group = "greeter";
    extraGroups = [ "video" "input" ];
  };

  users.groups.greeter = { };

  services.dbus.enable = true;
  systemd.user.services.greetd = {
    after = [ "dbus.service" "systemd-logind.service" "systemd-user-sessions.service" ];
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
}
