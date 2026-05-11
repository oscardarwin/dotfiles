{ pkgs, ... }: {
  services.udiskie.enable = true;

  home.packages = with pkgs; [
    udiskie
  ];
}
