pkgs: workspace: command:
let
  execute_in_workspace_script_path = pkgs.writeScript "execute_in_workspace.sh" (builtins.readFile ./execute_in_workspace.sh);
  run = "exec systemd-run --user --scope --quiet";

  modifier = "Mod1";
in
{
  "${modifier}+${workspace}" = ''exec swaymsg "${run} ${execute_in_workspace_script_path} ${command} ${workspace}"'';
  "${modifier}+Shift+${workspace}" = "move container to workspace ${workspace}";
} 


