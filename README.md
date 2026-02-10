TODO:

uai ubuntu:
 - screen positions

## Long Term
### Home Data Center
1. NextCloud
    1. Password Manager on Nextcloud
    2. Compressed/Encrypted Backups to Cloud Solution
2. Matrix Messenging

#### Plan
Nix machine runs services on boot. 
Make test docker container for the machine with resouces that mimic the machine I want to buy.

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
