{ config, pkgs, lib, ... }:
let
  modifier = config.wayland.windowManager.sway.config.modifier;
  execute_in_workspace_script_path = pkgs.writeScript "execute_in_workspace.sh" (builtins.readFile ./window-manager/execute_in_workspace.sh);
in
{
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault
    {
      "${modifier}+s" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} slack s"'';
      "${modifier}+v" = lib.mkForce ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} discord v"'';
      "${modifier}+i" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} pycharm-professional i"'';
      "${modifier}+w" = lib.mkForce ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} chromium w"'';
    };
} 
