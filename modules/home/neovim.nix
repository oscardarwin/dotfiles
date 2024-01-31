{ inputs, pkgs, ... }: 
{
  home.packages = [
    # telescope dependencies 
    # pkgs.ripgrep
    # pkgs.fd

    # lsp dependencies
    pkgs.nil
    # pkgs.nodePackages.typescript-language-server
    # pkgs.nodePackages.pyright
    # pkgs.rust-analyzer
    # pkgs.nodePackages.volar
    # pkgs.marksman

    # # formatter dependencies
    # pkgs-unstable.prettierd
    # pkgs.black
    pkgs.nixfmt
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    plugins.lightline.enable = true;
  };

  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;

  #   plugins = with pkgs.vimPlugins; [
  #       # neo-tree-nvim

  #       # telescope-nvim
  #       # telescope-fzf-native-nvim
  #       # nvim-web-devicons
  #       # telescope-undo-nvim

  #       # (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
  #       #   p.nix
  #       #   p.typescript
  #       #   p.rust
  #       #   p.javascript
  #       #   p.python
  #       #   p.markdown
  #       #   p.html
  #       #   p.vue
  #       #   p.css
  #       #   p.scss
  #       #   p.yaml
  #       #   p.toml
  #       #   p.json
  #       # ]))

  #       nvim-lspconfig

  #       # nvim-cmp
  #       # cmp-treesitter
  #       # cmp-rg
  #       cmp-nvim-lsp
  #       # luasnip
  #       # cmp_luasnip
  #       # friendly-snippets
  #       # cmp-nvim-lsp-signature-help

  #       # vim-surround
  #       # autoclose-nvim

  #       # trouble-nvim

  #       # catppuccin-nvim

  #       # improvedft

  #       # format-on-save-nvim
  #     ];
  # };
}

