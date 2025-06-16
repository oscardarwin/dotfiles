{ pkgs, ... }: {
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "auto-allocate-uids"
  ];
}
