{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    mkIf
    mkMerge
    types
    mapAttrs'
    nameValuePair;

  cfg = config.programs.pco-sway;

  mkModifierString = mods:
    lib.concatStringsSep "+" mods;

  runner =
    "exec ${cfg.clientPackage}/bin/client";

  allKeys =
    lib.unique (
      builtins.attrNames cfg.setWorkspaceKeybindings
      ++ cfg.extraKeys
    );

  contextBindings =
    mapAttrs'
      (key: _: nameValuePair
        "${mkModifierString cfg.contextSwitchKeyModifiers}+${key}"
        "${runner} create-or-switch-to-context ${key}"
      )
      (lib.genAttrs allKeys (_: null));

  moveToWorkspaceBindings =
    mapAttrs'
      (key: _: nameValuePair
        "${mkModifierString cfg.moveToWorkspaceModifiers}+${key}"
        "${runner} move-to-workspace ${key}"
      )
      (lib.genAttrs allKeys (_: null));

  moveToContextBindings =
    mapAttrs'
      (key: _: nameValuePair
        "${mkModifierString cfg.moveToContextModifiers}+${key}"
        "${runner} move-to-context ${key}"
      )
      (lib.genAttrs allKeys (_: null));

  moveToOutputBindings =
    mapAttrs'
      (key: _: nameValuePair
        "${mkModifierString cfg.moveToOutputModifiers}+${key}"
        "${runner} move-to-output ${key}"
      )
      (lib.genAttrs allKeys (_: null));

  switchToOutputBindings =
    mapAttrs'
      (key: _: nameValuePair
        "${mkModifierString cfg.switchToOutputModifiers}+${key}"
        "${runner} switch-to-output ${key}"
      )
      (lib.genAttrs allKeys (_: null));

  workspaceSwitchBindings =
    mapAttrs'
      (key: _:
        let
          maybeEntry = cfg.setWorkspaceKeybindings.${key} or null;
          command =
            if maybeEntry != null then
              "${runner} create-or-switch-to-set-workspace "
              + "${maybeEntry.workspaceName} "
              + "${maybeEntry.executable}"
            else
              "${runner} create-or-switch-to-workspace ${key}";
        in
        nameValuePair
          "${mkModifierString cfg.workspaceSwitchKeyModifiers}+${key}"
          command
      )
      (lib.genAttrs allKeys (_: null));

in
{
  options.programs.pco-sway = {

    enable = mkOption {
      type = types.bool;
      default = false;
    };

    clientPackage = mkOption {
      type = types.package;
      description = "The PCO package providing the client binary.";
    };

    daemonPackage = mkOption {
      type = types.package;
      description = "The PCO package providing the daemon binary.";
    };

    setWorkspaceKeybindings = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          workspaceName = mkOption {
            type = types.str;
          };
          executable = mkOption {
            type = types.str;
          };
        };
      });
      default = { };
    };

    extraKeys = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Keys to generate bindings for even if not in setWorkspaceKeybindings.";
    };

    contextSwitchKeyModifiers = mkOption {
      type = types.listOf types.str;
      default = [ "Mod4" ];
    };

    moveToContextModifiers = mkOption {
      type = types.listOf types.str;
      default = [ "Mod4" "Shift" ];
    };

    moveToWorkspaceModifiers = mkOption {
      type = types.listOf types.str;
      default = [ "Mod1" "Shift" ];
    };

    workspaceSwitchKeyModifiers = mkOption {
      type = types.listOf types.str;
      default = [ "Mod1" ];
    };

    switchToOutputModifiers = mkOption {
      type = types.listOf types.str;
      default = [ "Mod4" "Mod1" ];
    };

    moveToOutputModifiers = mkOption {
      type = types.listOf types.str;
      default = [ "Mod4" "Mod1" "Shift" ];
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;

      config.keybindings =
        mkMerge [
          contextBindings
          moveToWorkspaceBindings
          workspaceSwitchBindings
          moveToContextBindings
          moveToOutputBindings
          switchToOutputBindings
        ];
    };
  };
}












