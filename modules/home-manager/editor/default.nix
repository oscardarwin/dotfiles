{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./auto-complete.nix
    ./lsp.nix
    ./debugger.nix
  ];

  programs.nixvim = {
    enable = true;

    opts = {
      number = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      relativenumber = true;
      smartindent = true;
      hlsearch = false;
      incsearch = true;
      scrolloff = 8;
      colorcolumn = "0";
    };

    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true;
    clipboard.providers.xclip.enable = true;

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
      gitgutter.enable = true;
    };
  };
}
