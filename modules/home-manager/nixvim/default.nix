{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./auto-complete.nix
    ./lsp.nix
    # ./debugger.nix
  ];

  programs.nixvim = {
    nixpkgs.config.allowUnfree = true;

    enable = true;

    colorschemes.nightfox.enable = true;

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
      lsp-lines.enable = true;
      illuminate.enable = true;
      leap.enable = true;
      telescope = {
        enable = true;
        extensions = {
          undo.enable = true;
          manix.enable = true;
          ui-select.enable = true;
        };
      };
      web-devicons.enable = true;
      lualine = {
        enable = true;
        settings = {
          sections = {
            lualine_b = [{ __unkeyed-1 = "filename"; path = 1; }];
            lualine_c = [ "buffers" ];
            lualine_y = [ "diff" "diagnostics" ];
            lualine_z = [ "branch" ];
          };

        };
      };
      gitsigns.enable = true;
      codecompanion = {
        enable = true;
      };
    };
  };
}
