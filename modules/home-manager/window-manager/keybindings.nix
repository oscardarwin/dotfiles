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
      sed-brightnessctl = "sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p'";
      brightness-notification-id = "1";

      brightness-increase = pkgs.writeShellScript "brightnessctl-inc" ''
        current_brightness=$(${pkgs.brightnessctl}/bin/brightnessctl | ${sed-brightnessctl})
        new_brightness=$(echo "(sqrt($current_brightness)+1)^2"|${pkgs.bc}/bin/bc)
        ${pkgs.brightnessctl}/bin/brightnessctl set ''${new_brightness}%
        ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_brightness --replace-id ${brightness-notification-id} "Brightness"
      '';

      brightness-decrease = pkgs.writeShellScript "brightnessctl-dec" ''
        current_brightness=$(${pkgs.brightnessctl}/bin/brightnessctl | ${sed-brightnessctl})
        new_brightness=$(echo "(sqrt($current_brightness)-1)^2"|${pkgs.bc}/bin/bc)
        ${pkgs.brightnessctl}/bin/brightnessctl set ''${new_brightness}%
        ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_brightness --replace-id ${brightness-notification-id} "Brightness"
      '';

      run = "exec systemd-run --user --scope --quiet";

      setup_numbered_workspace = number: {
        "${modifier}+${number}" = "workspace number ${number}";
        "${modifier}+Shift+${number}" = "move container to workspace number ${number}";
      };

      setup_lettered_workspace = { letter, program ? menu }: {
        "${modifier}+${letter}" = ''exec swaymsg "${run} ${execute_in_workspace_script_path} '${program}' ${letter}"'';
        "${modifier}+Shift+${letter}" = ''move container to workspace ${letter}'';
      };
    in
    {
      "${modifier}+q" = "kill";
      "${modifier}+o" = "exec ${menu}";
      "${modifier}+d" = "nop";

      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";

      "${modifier}+Shift+l" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+h" = "move right";

      "${modifier}+r" = "mode resize";
      "${modifier}+v" = "split h; exec kitty";
      "${modifier}+s" = "split v; exec kitty";

      # Volume
      "--no-repeat --no-warn XF86AudioRaiseVolume" = "exec ${volume-increase}";
      "--no-repeat --no-warn XF86AudioLowerVolume" = "exec ${volume-decrease}";
      "--no-repeat --no-warn XF86AudioMute" = "exec ${volume-toggle}";

      # Screenshot
      "--no-repeat --no-warn Print" = "exec grim -g \"$(slurp)\" - | wl-copy";

      # Brightness
      "--no-repeat --no-warn XF86MonBrightnessUp" = "exec ${brightness-increase}";
      "--no-repeat --no-warn XF86MonBrightnessDown" = "exec ${brightness-decrease}";
    } // lib.foldr (elem: acc: (setup_numbered_workspace elem) // acc) { } [
      "0"
      "1"
      "2"
      "3"
      "4"
      "5"
      "6"
      "7"
      "8"
      "9"
    ] // lib.foldr (elem: acc: (setup_lettered_workspace elem) // acc) { } [
      {
        letter = "w";
        program = "qutebrowser";
      }
      {
        letter = "m";
        program = "${launch_ncspot}";
      }
      {
        letter = "e";
      }
      {
        letter = "d";
      }
      {
        letter = "f";
      }
      {
        letter = "p";
        program = "1password";
      }
    ];
}

