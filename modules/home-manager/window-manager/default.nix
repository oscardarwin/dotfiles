{ pkgs, config, lib, ... }: {
  imports = [ ./waybar.nix ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
  };

  wayland.windowManager.sway = {
    enable = true;

    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
    '';

    config = {
      # General
      modifier = "Mod1";
      terminal = "alacritty";
      bars = [ ];

      keybindings =
        let
          keybindingsModule = import ../keybindings.nix;
        in
        (keybindingsModule { inherit pkgs lib config; }).sway;
    };
  };

  home.packages = with pkgs; [ xdg-utils ];

  xdg.enable = true;

  # enable screensharing in Wayland
  # xdg.portal = {
  #   enable = true;
  #   # wlr.enable = true;
  #   # config.common.default = [ "wlr" "gtk" ];

  #   # extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  # };
}
