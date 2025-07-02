{ config, pkgs, lib, ... }:
let
  modifier = config.wayland.windowManager.sway.config.modifier;
  execute_in_workspace_script_path = pkgs.writeScript "execute_in_workspace.sh" (builtins.readFile ./window-manager/execute_in_workspace.sh);

  run = "exec systemd-run --user --scope --quiet";

in
{
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault
    {
      "${modifier}+w" = lib.mkForce ''exec swaymsg "${run} ${execute_in_workspace_script_path} chromium w"'';
      "${modifier}+c" = lib.mkForce ''exec swaymsg "${run} ${execute_in_workspace_script_path} slack c"'';
    };
} 
