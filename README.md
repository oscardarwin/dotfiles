TODO:

uai ubuntu:
 - screen positions
 - screen sharing

nvim instead of obsidian.
debugger

## Rebuild
sudo nixos-rebuild switch --flake .#squirtle --show-trace

## Delete Old Generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage -d

or

sudo nix-collect-garbage --delete-older-than 2d

! you may need to fix the bios when windows updates itself. 

## Neovim LSP

print out LSP capabilities:

`:lua =vim.lsp.get_clients()[1].server_capabilities`

## Sway Screen Orientation

focus the screen that you aren't moving, then list outputs:

`swaymsg -t get_outputs`

move unfocused screen to position

`swaymsg "output 'Dell Inc. DELL U2520D FRTJ923' pos -320 -1440"`

