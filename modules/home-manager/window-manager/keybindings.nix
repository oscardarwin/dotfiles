{ config, pkgs, lib, ... }: {

  wayland.windowManager.sway.config.keybindings =
    let
      modifier = config.wayland.windowManager.sway.config.modifier;
      menu = config.wayland.windowManager.sway.config.menu;
      execute_in_workspace_script_path = pkgs.writeScript "execute_in_workspace.sh" (builtins.readFile ./execute_in_workspace.sh);
      launch_ncspot = pkgs.writeScript "launch_ncspot.sh" ''kitty -e ncspot'';

      volume-notification-id = "2";

      volume_set_command = new_volume: "${pkgs.libnotify}/bin/notify-send --hint int:value:${new_volume} --replace-id ${volume-notification-id} \"Volume\"";

      volume-increase = pkgs.writeShellScript "volume-increase" ''
        new_volume=$(${pkgs.pamixer}/bin/pamixer -i 5 --get-volume)
        ${volume_set_command "new_volume"} 
      '';
      volume-decrease = pkgs.writeShellScript "volume-decrease" ''
        new_volume=$(${pkgs.pamixer}/bin/pamixer -d 5 --get-volume)
        ${volume_set_command "new_volume"} 
      '';
      volume-toggle = pkgs.writeShellScript "volume-toggle" ''
        ${pkgs.pamixer}/bin/pamixer -t
          if [ "$(${pkgs.pamixer}/bin/pamixer --get-mute)" = "true" ]; then
            ${volume_set_command "0"} 
          else
            ${volume_set_command "100"} 
          fi
      '';

      run = "exec systemd-run --user --scope --quiet";
    in
    lib.mkOptionDefault {
      "${modifier}+w" = ''exec swaymsg "${run} ${execute_in_workspace_script_path} qutebrowser w"'';
      "${modifier}+p" = ''exec wofi_1password_picker'';
      "${modifier}+m" = ''exec swaymsg "${run} ${execute_in_workspace_script_path} ${launch_ncspot} m"'';
      "${modifier}+q" = "kill";
      "${modifier}+d" = "exec ${menu}";

      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";

      "${modifier}+Shift+l" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+h" = "move right";

      "${modifier}+f" = "fullscreen toggle";

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

      "${modifier}+v" = "split h; exec kitty";
      "${modifier}+s" = "split v; exec kitty";

      "${modifier}+e" = "nop";

      # Volume
      "--no-repeat --no-warn XF86AudioRaiseVolume" = "exec ${volume-increase}";
      "--no-repeat --no-warn XF86AudioLowerVolume" = "exec ${volume-decrease}";
      "--no-repeat --no-warn XF86AudioMute" = "exec ${volume-toggle}";

      # Screenshot
      "--no-repeat --no-warn Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
    };
}
