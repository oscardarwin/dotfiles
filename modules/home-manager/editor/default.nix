{ lib, inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./auto-complete.nix
    ./lsp.nix
  ];

  programs.nixvim = {
    enable = true;

    options = {
      number = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      relativenumber = false;
      smartindent = true;
      hlsearch = false;
      incsearch = true;
      scrolloff = 8;
      updatetime = 50;
      colorcolumn = "80";
    };

    colorscheme = lib.mkForce "tokyonight";
    colorschemes.tokyonight.enable = true;

    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true;

    plugins = {
      lightline = {
        enable = true;
      };
      leap.enable = true;
      telescope = {
        enable = true;
        extensions = {
          undo.enable = true;
        };
      };
      lualine.enable = true;
    };
  };
}
