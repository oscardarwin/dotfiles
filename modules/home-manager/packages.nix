{ pkgs, ... }: {
  home.packages = [
    pkgs.libresprite
    pkgs.musescore
    pkgs.muse-sounds-manager
    pkgs.rclone
    pkgs.lilypond
    pkgs.fluidsynth
    pkgs.ffmpeg
    pkgs.soundfont-fluid
  ];
}
