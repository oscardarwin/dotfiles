{ inputs, pkgs, ... }: 
{
  home-manager.users.hallayus = {
    programs.neovim = inputs.neovim-config;
  };
}

