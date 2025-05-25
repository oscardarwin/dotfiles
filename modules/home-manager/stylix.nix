{ pkgs, ... }: {
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";

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
    };
  };
}
