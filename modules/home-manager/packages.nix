{ pkgs, ... }: {
  home.packages = with pkgs; [
    libresprite
    musescore
    muse-sounds-manager
    rclone
  ];
}
