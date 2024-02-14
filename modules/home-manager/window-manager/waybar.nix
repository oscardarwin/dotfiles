{ lib, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = lib.importJSON ./waybar-config.json;
    };
    style = lib.mkForce ./style.css;
  };
}
