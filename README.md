TODO:




nixd completions still not working
fix overlapping capabilities in nixd/nil 
maybe just move to rust-tools
undo-tree


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

