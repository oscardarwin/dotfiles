{ pkgs, ... }: {
  wayland.windowManager.sway.config.startup = [
    { command = "waybar"; }
  ];
}
