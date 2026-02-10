{ pkgs, ... }: {
  imports = [
    ./waybar.nix
    ./keybindings.nix
    ./keyboard_missing_warning.nix
  ];

  home = {
    sessionVariables = {
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
    pointerCursor = {
      enable = true;
      sway.enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors-white";
      size = 24;
    };
  };

  gtk.cursorTheme = {
    name = "capitaine-cursors-white";
    package = pkgs.capitaine-cursors;
    size = 24;
  };
  wayland.windowManager.sway = {
    enable = true;

    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
    '';

    wrapperFeatures.gtk = true;
    systemd.enable = true;

    config = {
      menu = "wofi --show run";
      modifier = "Mod1";
      terminal = "kitty";
      bars = [ ];
      defaultWorkspace = "workspace number 1";
      window.titlebar = false;
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "chromium.desktop" ];
    "text/xml" = [ "chromium.desktop" ];
    "x-scheme-handler/http" = "chromium.desktop";
    "x-scheme-handler/https" = "chromium.desktop";
    "application/https" = "chromium.desktop";
  };

}
