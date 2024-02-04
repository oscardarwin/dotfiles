TODO STILL:

- add command for starting development environment with nvim
- leap in vim
- firefox plugins and bookmarks
  - 1password
  - ublock origin
  - translation

sudo nixos-rebuild switch --flake .#squirtle --show-trace

## Delete Old Generations


sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage -d

or

sudo nix-collect-garbage --delete-older-than 2d

! you may need to fix the bios when windows updates itself. 


