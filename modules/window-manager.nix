{ pkgs, inputs, config, lib, ... }: {
  hardware.opengl.enable = true;
  home-manager.users.hallayus = {
    home.sessionVariables = {
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
        modifier = "Mod1";
        terminal = "alacritty";
        fonts = {
	  names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
          style = "Bold Semi-Condensed";
          size = 11.0;
        };

        #gaps = {
        #  inner = 2;
        #  outer = -2;
        # };
      };
    };
  };
}
