{ inputs, ... }:
{
  home-manager.users.hallayus = {
    inherit inputs.neovim-config 
  };
}
