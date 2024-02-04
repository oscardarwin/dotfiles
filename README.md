TODO STILL:

- copy buffer in vim
- leap in vim
- lazygit
- vim commands for sway
- add command for starting development environment with nvim

firefox
    - bookmarks

sudo nixos-rebuild switch --flake .#squirtle --show-trace

## Delete Old Generations


sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage -d

or

sudo nix-collect-garbage --delete-older-than 2d


