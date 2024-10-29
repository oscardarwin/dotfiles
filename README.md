TODO:

uai ubuntu:
 - screen positions
 - screen sharing

nixd completions still not working
fix overlapping capabilities in nixd/nil 

maybe just move to rust-tools

plugins.rust-tools.server.rename.allowExternalItems = true;
lspkind
undo-tree
clippy

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

## Take a screenshot

```
nix-shell -p grim slurp wl-clipboard
grim -g "$(slurp)" > my_file.png
```
