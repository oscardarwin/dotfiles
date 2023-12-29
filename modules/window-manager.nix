{ pkgs, inputs, config, lib, ... }: {
  hardware.opengl.enable = true;
  home-manager.users.hallayus = {
    home.sessionsVariables = {
      XDG_CURRENT_DESKTOP = "sway";
    };
    

    # Configure sway
    wayland.windowManager.sway = {
       

      extraSessionCommands = ''
        export WLR_NO_HARDWARE_CURSORS=1
      '';

      enable = true;

      config = {
        # General
        modifier = "Mod4";

        fonts = {
          style = "";
          size = 10.0;
        };

        gaps = {
          inner = 2;
          outer = -2;
        };
      };
    };
  };
}
