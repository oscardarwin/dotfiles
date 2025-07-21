{ pkgs, inputs, ... }:
let
  qutebrowser = "org.qutebrowser.qutebrowser.desktop";
in
{
  home.packages = [
    pkgs.libresprite
    pkgs.rclone
    pkgs.lilypond
    pkgs.fluidsynth
    pkgs.ffmpeg
    pkgs.soundfont-fluid
    pkgs.zathura
    pkgs.viu
    pkgs._1password-gui
    inputs.wofi-1password-picker.packages."x86_64-linux".default
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ qutebrowser ];
    "text/xml" = [ qutebrowser ];
    "x-scheme-handler/http" = [ qutebrowser ];
    "x-scheme-handler/https" = [ qutebrowser ];
  };
}
