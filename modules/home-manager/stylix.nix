{ pkgs, ... }: {
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
    image = ./background.png;

    targets = {
      kitty.enable = true;
      nixvim.enable = true;
      ncspot.enable = true;
      waybar = {
        enable = true;
        enableCenterBackColors = true;
        enableLeftBackColors = true;
        enableRightBackColors = true;
      };
      sway.enable = true;
      qutebrowser.enable = true;
      starship.enable = true;
      lazygit.enable = true;
      feh.enable = true;
      btop.enable = true;
      bat.enable = true;
      swaylock = {
        enable = true;
        useWallpaper = true;
      };
    };
  };
}
