{ pkgs, inputs, config, lib, ... }: {
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
  };

  wayland.windowManager.sway = {

    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
    '';

    enable = true;

    config = {
      # General
      modifier = "Mod1";
      terminal = "alacritty";

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
          execute_in_workspace_script_path = pkgs.writeScript "execute_in_workspace.sh" ''
            #!/bin/sh
            WORKSPACE_NAME=$2
            TO_EXECUTE=$1
            WORKSPACE_EXISTS=$(exec swaymsg -t get_workspaces | grep '"name": "'$WORKSPACE_NAME'"')
            if [ -n "$WORKSPACE_EXISTS" ]; then exec swaymsg "workspace $WORKSPACE_NAME"
            else swaymsg "workspace $WORKSPACE_NAME; exec $TO_EXECUTE"
            fi
          '';
          launch_lazygit_with_ssh_agent = pkgs.writeScript "launch_ssh_agent_and_lazygit.sh" ''
            #!/bin/sh
            eval "$(ssh-agent -c)"
            ssh-add ~/.ssh/github"
            exec lazygit
          '';
        in
        lib.mkOptionDefault {
          "${modifier}+w" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} firefox w"'';
          "${modifier}+g" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} 'alacritty -e ${launch_lazygit_with_ssh_agent}'  g"'';
        };
    };
  };
}
