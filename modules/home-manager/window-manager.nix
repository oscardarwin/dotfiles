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
    };
  };
}
