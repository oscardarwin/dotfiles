{ inputs, pkgs, ... }:
{
  home-manager.users.hallayus = {
    imports = [
      # inputs.nixvim.homeManagerModules.nixvim
      ./neovim.nix
    ];
  };
}

