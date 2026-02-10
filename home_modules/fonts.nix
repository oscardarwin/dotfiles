{ pkgs, ... }: {
  home.packages = [
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.droid-sans-mono
  ];

  fonts.fontconfig.enable = true;
}
