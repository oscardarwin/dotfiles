{ config, pkgs, lib, ... }: {

  wayland.windowManager.sway.config.keybindings =
    let
      modifier = config.wayland.windowManager.sway.config.modifier;
      menu = config.wayland.windowManager.sway.config.menu;
      execute_in_workspace_script_path = pkgs.writeScript "execute_in_workspace.sh" (builtins.readFile ./window-manager/execute_in_workspace.sh);
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
    in
    lib.mkOptionDefault {
      "${modifier}+w" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} firefox w"'';
      "${modifier}+g" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} ${launch_lazygit} g"'';
      "${modifier}+e" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} ${launch_neovim} e"'';
      "${modifier}+p" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} 1password p"'';
      "${modifier}+o" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} obsidian o"'';
      "${modifier}+q" = "kill";
      "${modifier}+d" = "exec ${menu}";
      "${modifier}+Left" = "focus left";
      "${modifier}+Down" = "focus down";
      "${modifier}+Up" = "focus up";
      "${modifier}+Right" = "focus right";

      "${modifier}+Shift+Left" = "move left";
      "${modifier}+Shift+Down" = "move down";
      "${modifier}+Shift+Up" = "move up";
      "${modifier}+Shift+Right" = "move right";

      "${modifier}+Shift+Ctrl+Left" = "nop";
      "${modifier}+Shift+Ctrl+Right" = "nop";

      "${modifier}+h" = "nop";
      "${modifier}+v" = "nop";
      "${modifier}+f" = "fullscreen toggle";

      "${modifier}+Shift+space" = "nop";

      "${modifier}+a" = "nop";

      "${modifier}+1" = "workspace number 1";
      "${modifier}+2" = "workspace number 2";
      "${modifier}+3" = "workspace number 3";
      "${modifier}+4" = "workspace number 4";
      "${modifier}+5" = "workspace number 5";
      "${modifier}+6" = "workspace number 6";
      "${modifier}+7" = "workspace number 7";
      "${modifier}+8" = "workspace number 8";
      "${modifier}+9" = "workspace number 9";
      "${modifier}+0" = "workspace number 10";

      "${modifier}+Shift+1" = "move container to workspace number 1";
      "${modifier}+Shift+2" = "move container to workspace number 2";
      "${modifier}+Shift+3" = "move container to workspace number 3";
      "${modifier}+Shift+4" = "move container to workspace number 4";
      "${modifier}+Shift+5" = "move container to workspace number 5";
      "${modifier}+Shift+6" = "move container to workspace number 6";
      "${modifier}+Shift+7" = "move container to workspace number 7";
      "${modifier}+Shift+8" = "move container to workspace number 8";
      "${modifier}+Shift+9" = "move container to workspace number 9";
      "${modifier}+Shift+0" = "move container to workspace number 10";

      "${modifier}+Shift+c" = "reload";
      "${modifier}+Shift+r" = "restart";

      "${modifier}+r" = "mode resize";

      "${modifier}+Return" = "exec alacritty";
    };

  programs.nixvim.keymaps = [
    {
      action = "<cmd>Telescope find_files<cr>";
      key = "ff";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope lsp_document_symbols<cr>";
      key = "fs";
      options = {
        silent = true;
      };
    }
    {
      action = "vim.lsp.buf.definition";
      key = "gd";
      lua = true;
    }
    {
      action = "vim.lsp.buf.references";
      key = "gr";
      lua = true;
    }
    {
      action = "vim.lsp.buf.type_definition";
      key = "gt";
      lua = true;
    }
    {
      action = "vim.lsp.buf.implementation";
      key = "gi";
      lua = true;
    }
    {
      action = "vim.lsp.buf.hover";
      key = "gh";
      lua = true;
    }
  ];

  programs.nixvim.plugins.nvim-cmp.mapping = {
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
}
