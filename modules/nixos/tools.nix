{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.nixd
    pkgs.nixdoc
  ];
}
