{ config, pkgs, lib, ... }: {
  sway = let
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
    launch_neovim = pkgs.writeScript "launch_neovim.sh" ''
      #!/bin/sh
      swaymsg "workspace e; exec alacritty -e nvim;"
      sleep 0.1s
      swaymsg "workspace e; exec alacritty, move down; layout splitv;"
      sleep 0.1s
      swaymsg "workspace e; resize set height 30ppt"
    '';
    launch_lazygit = pkgs.writeScript "launch_lazygit.sh" ''
      alacritty -e lazygit
    '';
  in lib.mkOptionDefault {
    "${modifier}+w" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} firefox w"'';
    "${modifier}+g" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} ${launch_lazygit} g"'';
    "${modifier}+e" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} ${launch_neovim} e"'';
    "${modifier}+p" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} 1password p"'';
  };

  nixvimBase = [
    {
      action = "<cmd>Telescope find_files<CR>";
      key = "ff";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope lsp_document_symbols<CR>";
      key = "fs";
      options = {
        silent = true;
      };
    }
  ];

  nixvimCmpMapping =  {
    "<CR>" = "cmp.mapping.confirm({ select = true })";
    "C-Space" = "cmp.mapping.complete()";
    "<Tab>" = {
      action = ''
        function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end
      '';
      modes = [ "i" "s" ];
    };
  };

  nixvimLspMapping = {
    "gd" = "definition";
    "gD" = "references";
    "gt" = "type_definition";
    "gi" = "implementation";
    "K" = "hover";
  };
}