{ lib, config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  programs.swaylock = {
    enable = true;
    settings = {
      font-size = 112;
      indicator-idle-visible = true;
      indicator-radius = 230;
      indicator-thickness = 40;
      show-failed-attempts = true;
      indicator-caps-lock = true;
      inside-color = lib.mkForce "ffffff00";
      inside-wrong-color = lib.mkForce "ffffff00";
      inside-ver-color = lib.mkForce "ffffff00";
      text-ver-color = lib.mkForce "${colors.base01}aa";
      text-error-color = lib.mkForce "${colors.base01}aa";
    };
  };
}
