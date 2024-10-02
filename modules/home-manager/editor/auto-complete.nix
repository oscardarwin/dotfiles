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
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "treesitter"; }
          { name = "luasnip"; }
          { name = "clippy"; }
          { name = "nvim_lua"; }
        ];

        lspkind.enable = true;
      };
    };
  };
}
