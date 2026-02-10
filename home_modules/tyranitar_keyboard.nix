{ ... }: {
  wayland.windowManager.sway.extraConfig = ''
    input * {
      xkb_layout "gb"
    }
  '';
}
