{ config, lib, pkgs, ... }:

let
  cfg = config.services.contextd;
in
{
  options.services.contextd = {

    enable = lib.mkEnableOption "Sway context daemon";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.contextd or null;
      description = "contextd package to use";
    };

    keybindings = lib.mkOption {
      description = "Complete keybinding configuration for contextd";
      type = lib.types.submodule {
        options = {

          contextMap = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            example = { d = "dnd"; m = "maths"; };
            description = "Mapping from single letter to context name";
          };

          monitorMap = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            example = { t = "DP-1"; b = "HDMI-A-1"; };
            description = "Mapping from single letter to monitor name";
          };

          workspaceMap = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            example = { "1" = "1"; "2" = "2"; };
            description = "Mapping from single letter to workspace identifier";
          };

          contextModifiers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "Mod4" ];
            description = "Modifier keys for context switching";
          };

          monitorModifiers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "Mod4" "Shift" ];
            description = "Modifier keys for monitor switching";
          };

          workspaceModifiers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "Mod4" ];
            description = "Modifier keys for workspace switching";
          };

          workspaceMoveModifiers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "Mod4" "Ctrl" ];
            description = "Modifier keys for moving workspace";
          };
        };
      };

      default = { };
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = [ cfg.package ];

    # JSON now contains only keybindings
    xdg.configFile."contextd/config.json".text =
      builtins.toJSON cfg.keybindings;

    systemd.user.services.contextd = {
      Unit = {
        Description = "Sway Context IPC Daemon";
      };

      Service = {
        ExecStart = "${cfg.package}/bin/contextd";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
