{ inputs, pkgs, ... }:
{
  home-manager.users.hallayus = {
    imports = [
      ./neovim.nix
    ];
  };
}

