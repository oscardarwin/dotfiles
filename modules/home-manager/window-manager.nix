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
          web_browser_script_path = pkgs.writeScript "open_web_browser.sh" ''
            #!/bin/sh
            WORKSPACE_NAME="w"
            WORKSPACE_EXISTS=$(exec swaymsg -t get_workspaces | grep '"name": "'$WORKSPACE_NAME'"')
            if [ -n "$WORKSPACE_EXISTS" ]; then exec swaymsg "workspace $WORKSPACE_NAME"
            else swaymsg "workspace $WORKSPACE_NAME; exec firefox"
            fi
          '';
          #  web_browser_script_path = builtins.toFile "open_web_browser.sh" "
          #    #!\bin\sh
          #    echo \"creating\"
          #    CURRENT_TREE=$(swaymsg -t get_tree)
          #    sway workspace w
          #    if [[*\"workspace \"w\"\"* != $CURRENT_TREE]]; then 
          #      firefox
          #    fi
          #  ";
        in
        lib.mkOptionDefault {
          "${modifier}+w" = ''exec swaymsg "exec alacritty -e ${web_browser_script_path}"'';
        };
    };
  };
}
