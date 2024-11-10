{ inputs, pkgs, lib, ... }:
let
  colors = {
    base00 = "272822";
    base01 = "383830";
    base02 = "49483e";
    base03 = "75715e";
    base04 = "a59f85";
    base05 = "f8f8f2";
    base06 = "f5f4f1";
    base07 = "f9f8f5";
    base08 = "f92672";
    base09 = "fd971f";
    base0A = "f4bf75";
    base0B = "a6e22e";
    base0C = "a1efe4";
    base0D = "66d9ef";
    base0E = "ae81ff";
    base0F = "cc6633";
  };

  hashed_colors = builtins.mapAttrs (name: value: "#" + value) colors;
in
{
  imports = [ inputs.stylix.homeManagerModules.stylix ];

  lib.stylix.colors = {
    withHashtag = hashed_colors // {
      bright-blue = hashed_colors.base0C;
      bright-cyan = hashed_colors.base0D;
      bright-green = hashed_colors.base0B;
      bright-magenta = hashed_colors.base0E;
      bright-red = hashed_colors.base08;
      yellow = hashed_colors.base0A;
      blue = hashed_colors.base0D;
      cyan = hashed_colors.base0C;
      green = hashed_colors.base0B;
      magenta = hashed_colors.base0E;
      red = hashed_colors.base08;
    };
    base01-hex = colors.base01;
    base0B-hex = colors.base0B;
    base05-hex = colors.base05;
    base08-hex = colors.base08;
    base04 = colors.base04;
    base01 = colors.base01;
  };
  stylix = {
    # enable = true;
    targets = {
      gnome.enable = false;
      kde.enable = false;
      fish.enable = false;
      gtk.enable = false;
      forge.enable = false;
    };
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

    base16Scheme = { yaml = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml"; use-ifd = "always"; };
  };
}
