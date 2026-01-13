{ lib, execute_in_workspace, ... }: {
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault
    (execute_in_workspace "w" "chromium" // execute_in_workspace "c" "slack");
} 
