{ unstable-pkgs, ... }: {
  home.packages = [
    unstable-pkgs.neonmodem
  ];

  programs.freetube.enable = true;
}
