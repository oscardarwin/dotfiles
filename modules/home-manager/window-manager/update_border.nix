{ pkgs, config, ... }:
let
  colors = config.lib.stylix.colors;
  uid = 1000;
  swaymsg = "${pkgs.sway}/bin/swaymsg";
  find = "${pkgs.findutils}/bin/find";
  wc = "${pkgs.coreutils}/bin/wc";
  inotifywait = "${pkgs.inotify-tools}/bin/inotifywait";
  date = "${pkgs.coreutils}/bin/date";

  keyboard-monitor-script = pkgs.writeShellScript "keyboard-monitor" ''
    #!/bin/bash
    set -eu

    log() {
      echo "$(${date} +'%F %T') [keyboard-monitor] $*" >&2
    }

    export XDG_RUNTIME_DIR=/run/user/${toString uid}
    device_dir="/dev/input/by-id"

    update_border() {
      log "Checking connected keyboards..."
      count=$(${find} "$device_dir" -maxdepth 1 -name '*event-kbd' 2>/dev/null | ${wc} -l)
      log "Found $count keyboard(s)"
      if [ "$count" -eq 0 ]; then
        log "No keyboards detected, setting border to 6"
        ${swaymsg} border normal 8 || log "swaymsg failed!"
        ${swaymsg} client.focused "${colors.base08}" "${colors.base00}" "${colors.base05}" "${colors.base08}" "${colors.base08}"
      else
        log "Keyboard(s) detected, setting border to 2"
        ${swaymsg} border normal 2 || log "swaymsg failed!"
        ${swaymsg} client.focused "${colors.base0D}" "${colors.base00}" "${colors.base05}" "${colors.base0B}" "${colors.base0D}"
      fi
    }

    log "Starting keyboard monitor script"

    # initial check
    update_border

    # watch for add/remove events
    while true; do
      log "Waiting for device changes..."
      ${inotifywait} -q -e create -e delete "$device_dir" || log "inotifywait failed!"
      update_border
    done
  '';
in
{
  home.packages = [ pkgs.inotify-tools ];

  systemd.user.services.keyboard-monitor = {
    Unit.Description = "update border size on no keyboard";

    Service = {
      ExecStart = keyboard-monitor-script;
      Restart = "always";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
