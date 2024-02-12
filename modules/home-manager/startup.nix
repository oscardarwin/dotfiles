{ pkgs, ... }:
{
  wayland.windowManager.sway.config.startup = [
    { command = "waybar"; }
    { command = "alacritty"; }
    { command = "swaylock"; }
  ];
}
