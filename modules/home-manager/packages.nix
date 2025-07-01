{ pkgs, ... }: {
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
  ];
}
