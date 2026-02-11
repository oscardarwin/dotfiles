{ pkgs, ... }: {
  home.packages = [
    pkgs.neonmodem
  ];

  programs.freetube.enable = true;
}
