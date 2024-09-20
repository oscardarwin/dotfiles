{
  programs.nixvim.plugins = {
    cmp.settings = {
      enable = true;
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
    };

    lspkind.enable = true;
  };
}
