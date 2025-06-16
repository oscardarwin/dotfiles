{ pkgs, ... }: {
  wayland.windowManager.sway.config.startup = [
    { command = "waybar"; }
  ];
  home.packages = [
    pkgs.jetbrains.clion
  ];
}
