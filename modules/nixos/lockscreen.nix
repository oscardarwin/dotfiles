{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.swaylock
  ];

  security.polkit.enable = true;
  security.pam.services.swaylock = { };
}
