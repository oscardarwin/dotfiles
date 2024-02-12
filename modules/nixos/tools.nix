{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nixd
    nixdoc
    bundix
  ];
}
