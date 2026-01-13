{ ... }: {
  programs.nixvim = {

    keymaps = [
      {
        action = ''
          <cmd>lua require("telescope.builtin").find_files({ hidden = false })<CR>
        '';
        key = "ff";
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope live_grep<cr>";
        key = "fg";
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope undo<cr>";
        key = "fu";
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope manix<cr>";
        key = "fn";
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope lsp_references<cr>";
        key = "gr";
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope lsp_workspace_symbols<cr>";
        key = "fs";
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Gitsigns preview_hunk<cr>";
        key = "gp";
        options = {
          silent = true;
        };
      }
      {
        action.__raw = "vim.lsp.buf.definition";
        key = "gd";
      }
      {
        action.__raw = "vim.lsp.buf.type_definition";
        key = "gt";
      }
      {
        action.__raw = "vim.lsp.buf.implementation";
        key = "gi";
      }
      {
        action.__raw = "vim.lsp.buf.hover";
        key = "gh";
      }
      {
        action.__raw = "vim.lsp.buf.rename";
        key = "R";
      }
      {
        action = "<cmd>edit %:p:h<cr>";
        key = "fn";
        options = {
          silent = true;
        };
      }
    ];

    plugins.cmp.settings.mapping = {
      "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i'})";
      "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i'})";
      "<CR>" = "cmp.mapping.confirm({ select = true })";
    };
  };
}
