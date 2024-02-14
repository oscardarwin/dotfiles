{ pkgs, lib, inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    options = {
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
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-nvim-lsp.enable = true;
      nvim-cmp = {
        enable = true;
        autoEnableSources = true;
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "treesitter"; }
          # {name = "luasnip";}
        ];
      };
      telescope = {
        enable = true;
        extensions = {
          undo.enable = true;
        };
      };
      lualine.enable = true;

      cmp-treesitter.enable = true;
      treesitter = {
        enable = true;
        incrementalSelection.enable = true;
        ensureInstalled = [ "nix" "bash" "c" "json" ];
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.passthru.builtGrammars; [
          bash
          c
          html
          javascript
          latex
          lua
          nix
          norg
          python
          rust
          vimdoc
        ];
      };

      lsp-format = {
        enable = true;
        setup = {
          nix = {
            sync = true;
          };
        };
      };
      cmp-nvim-lua.enable = true;
      lsp = {
        enable = true;

        servers = {
          nixd = {
            enable = true;
            rootDir = "";
            settings = {
              eval.workers = 3;

              formatting.command = "nixpkgs-fmt";
              options = {

                target = {
                  # flake-parts
                  # installable = "/flakeref#debug.options";

                  # nixOS configuration
                  # installable = "/flakeref#nixosConfigurations.<adrastea>.options";

                  # home-manager configuration
                  installable = "/home/hallayus/dotfiles#squirtle.options";
                };
              };
            };
          };
          nil_ls = {
            enable = true;
            installLanguageServer = true;
          };
          bashls = {
            enable = true;
            installLanguageServer = true;
            filetypes = [ "sh" ];
          };
          jsonls = {
            enable = true;
            installLanguageServer = true;
          };
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };
    };
  };
}
