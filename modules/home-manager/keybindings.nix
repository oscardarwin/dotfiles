{ config, pkgs, lib, ... }: {

  wayland.windowManager.sway.config.keybindings =
    let
      modifier = config.wayland.windowManager.sway.config.modifier;
      menu = config.wayland.windowManager.sway.config.menu;
      execute_in_workspace_script_path = pkgs.writeScript "execute_in_workspace.sh" (builtins.readFile ./window-manager/execute_in_workspace.sh);

      launch_ncspot = pkgs.writeScript "launch_ncspot.sh" ''alacritty -e ncspot'';
      launch_obsidian = pkgs.writeScript "launch_obsidian.sh" (builtins.readFile ./obsidian/launch.sh);

      volume-notification-id = "2";

      volume-increase = pkgs.writeShellScript "volume-increase" ''
        new_volume=$(${pkgs.pamixer}/bin/pamixer -i 5 --get-volume)
        ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_volume --replace-id ${volume-notification-id} "Volume"
      '';
      volume-decrease = pkgs.writeShellScript "volume-decrease" ''
        new_volume=$(${pkgs.pamixer}/bin/pamixer -d 5 --get-volume)
        ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_volume --replace-id ${volume-notification-id} "Volume"
      '';
      volume-toggle = pkgs.writeShellScript "volume-toggle" ''
        ${pkgs.pamixer}/bin/pamixer -t
          if [ "$(${pkgs.pamixer}/bin/pamixer --get-mute)" = "true" ]; then
            ${pkgs.libnotify}/bin/notify-send --hint int:value:0 --replace-id ${volume-notification-id} "Volume"
          else
            ${pkgs.libnotify}/bin/notify-send --hint int:value:100 --replace-id ${volume-notification-id} "Volume"
          fi
      '';
    in
    lib.mkOptionDefault {
      "${modifier}+w" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} qutebrowser w"'';
      "${modifier}+p" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} 1password p"'';
      "${modifier}+m" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} ${launch_ncspot} m"'';
      "${modifier}+o" = ''exec swaymsg "exec alacritty -e ${execute_in_workspace_script_path} ${launch_obsidian} o"'';
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

      # Volume
      "--no-repeat --no-warn XF86AudioRaiseVolume" = "exec ${volume-increase}";
      "--no-repeat --no-warn XF86AudioLowerVolume" = "exec ${volume-decrease}";
      "--no-repeat --no-warn XF86AudioMute" = "exec ${volume-toggle}";

      "--no-repeat --no-warn Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
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
      action = "<cmd>Telescope live_grep<cr>";
      key = "fg";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope undo<cr>";
      key = "fu";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope manix<cr>";
      key = "fn";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope lsp_workspace_symbols<cr>";
      key = "fs";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Gitsigns preview_hunk<cr>";
      key = "gp";
      options = {
        silent = true;
      };
    }
    {
      action.__raw = "vim.lsp.buf.definition";
      key = "gd";
    }
    {
      action.__raw = "vim.lsp.buf.references";
      key = "gr";
    }
    {
      action.__raw = "vim.lsp.buf.type_definition";
      key = "gt";
    }
    {
      action.__raw = "vim.lsp.buf.implementation";
      key = "gi";
    }
    {
      action.__raw = "vim.lsp.buf.hover";
      key = "gh";
    }
    {
      action.__raw = "vim.lsp.buf.rename";
      key = "R";
    }

  ];

  programs.nixvim.plugins.cmp.settings.mapping = {
    "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i'})";
    "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i'})";
    "<CR>" = "cmp.mapping.confirm({ select = true })";
  };
}


