{ inputs, pkgs, ... }:
{
  home-manager.users.hallayus = {
    modules = [
      ./neovim.nix
    ]; # this could be imports too.
  };
}

