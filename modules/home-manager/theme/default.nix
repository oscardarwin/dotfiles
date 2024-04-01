{ inputs, pkgs, ... }: {
  imports = [ inputs.stylix.homeManagerModules.stylix ];


  stylix =
    let
      theme = "${pkgs.base16-schemes}/share/themes/kimber.yaml";
      # theme = "light";
    in
    {
      image = ./nixos-wallpaper-clean.jpg;
      fonts = {
        serif = {
          package = pkgs.source-serif;
          name = "Source Serif";
        };

        sansSerif = {
          package = pkgs.source-sans;
          name = "Source Sans";
        };

        monospace = {
          package = pkgs.fira-code;
          name = "Fira Code";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };

      # polarity = "dark";

      base16Scheme = theme;
    };
}
