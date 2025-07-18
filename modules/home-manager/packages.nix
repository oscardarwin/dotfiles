{ pkgs, inputs, system, ... }: {
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
}
