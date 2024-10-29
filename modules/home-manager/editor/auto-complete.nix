{
  programs.nixvim.plugins = {
    luasnip.enable = true;
    cmp = {
      enable = true;
      settings = {
        experimental = { ghost_text = true; };
        autoEnableSources = true;
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        sources = [
          { name = "codeium"; }
          { name = "nvim_lsp"; }
          { name = "buffer"; }
          { name = "path"; }
          { name = "treesitter"; }
          { name = "luasnip"; }
        ];

        lspkind.enable = true;
      };
    };
    codeium-nvim.enable = true;
  };
}
