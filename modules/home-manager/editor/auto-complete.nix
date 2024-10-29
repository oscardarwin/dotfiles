{
  programs.nixvim.plugins = {
    luasnip.enable = true;
    lspkind = {
      enable = true;
      mode = "symbol";
      cmp.menu = {
        codeium = "[Codium]";
        nvim_lsp = "[LSP]";
        buffer = "[Buffer]";
        path = "[Path]";
        treesitter = "[Treesitter]";
        luasnip = "[LuaSnip]";
      };
    };

    cmp = {
      enable = true;
      settings = {
        view.docs.auto_open = true;
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
      };
    };
    codeium-nvim.enable = true;
  };
}
