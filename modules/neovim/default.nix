{ pkgs, pkgs-unstable, ... }:
{
  home-manager.users.hallayus = {

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [

      ];
    };
  };
}
