{ pkgs, ... }:
{
  wayland.windowManager.sway.config.startup = [
    { command = "alacritty"; }
    { command = "swaylock"; }
  ];
}
