{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.wiki-tui
  ];
}
