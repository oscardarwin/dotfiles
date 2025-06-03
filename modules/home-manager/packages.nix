{ pkgs, ... }: {
  home.packages = [
    pkgs.libresprite
    pkgs.musescore
    pkgs.muse-sounds-manager
    pkgs.rclone
    pkgs.frescobaldi
  ];
}
