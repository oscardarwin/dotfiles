{
  programs.nixvim.plugins = {
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-nvim-lsp.enable = true;
    nvim-cmp = {
      enable = true;
      snippet.expand = "luasnip";
      autoEnableSources = true;
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "treesitter"; }
        { name = "luasnip"; }
        { name = "clippy"; }
      ];
    };
    luasnip.enable = true;
    cmp-clippy.enable = true;
    cmp-treesitter.enable = true;

    cmp-nvim-lua.enable = true;
    lspkind.enable = true;
  };
}
