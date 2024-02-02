{ pkgs, inputs, config, lib, ... }: {
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  hardware.opengl.enable = true;
  home-manager.users.hallayus = {
    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
    };

    programs.swaylock.enable = true;

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
        # fonts = {
        #   names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
        #   style = "Bold Semi-Condensed";
        #   size = 11.0;
        # };
      };
    };
  };
}
