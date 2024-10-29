{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    rclone
  ];
  # TODO: do the rclone config automatically.
  # TODO: add service to start rclone for gdrive
}
