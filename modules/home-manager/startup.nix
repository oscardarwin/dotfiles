{ ... }:
{
  wayland.windowManager.sway.config.startup = [
    { command = "waybar"; }
    { command = "swaylock"; }
  ];
}
