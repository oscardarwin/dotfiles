{ pkgs, ... }: {
  imports = [ ./waybar.nix ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";

    CLUTTER_BACKEND = "wayland";
    ECORE_EVAS_ENGINE = "wayland_egl";
    ELM_ENGINE = "wayland_egl";
    GDK_BACKEND = "wayland";
    # chromium
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland-egl";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_WAYLAND_FORCE_DPI = "physical";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  wayland.windowManager.sway = {
    enable = true;

    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
    '';

    wrapperFeatures.gtk = true;

    systemd.enable = true;

    config = {
      # General
      modifier = "Mod1";
      terminal = "alacritty";
      bars = [ ];
    };
  };

  # home.packages = with pkgs; [ xdg-utils ];

  # xdg.enable = true;

  # enable screensharing in Wayland
  # xdg.portal = {
  #   enable = true;
  #   config.common.default = [ "wlr" "gtk" ];

  #   extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
  # };

  # systemd.user.services = {
  #   xdg-desktop-portal-wlr = {
  #     Unit = {
  #       After = [ "graphical-session.target" ];
  #       Description = "xdg-desktop-portal-wlr";
  #       PartOf = [ "graphical-session.target" ];
  #       ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
  #     };

  #     Service = {
  #       ExecStart =
  #         "${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr";
  #       Restart = "on-failure";
  #       BusName = "org.freedesktop.impl.portal.desktop.wlr";
  #       Type = "dbus";
  #     };
  #   };
  # };
}
