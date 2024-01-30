{ config, pkgs, ... }:

{
  home.username = "oscar";
  home.homeDirectory = "/home/oscar";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}