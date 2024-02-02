{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.mprocs
  ];

  home-manager.users.hallayus = {
    wayland.windowManager.sway.config.startup = [
      { command = "alacritty -e mprocs --config ${./mprocs.yaml}"; }
      { command = "swaylock"; }
    ];
  };
}
