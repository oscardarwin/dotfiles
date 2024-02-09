{ pkgs, lib, inputs, ... }:
{
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

    keymaps = [
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "ff";
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope lsp_document_symbols<CR>";
        key = "fs";
        options = {
          silent = true;
        };
      }
    ];

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
          # { name = "path"; }
          # { name = "buffer"; }
          # { name = "treesitter"; }
          # {name = "luasnip";}
        ];
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "C-Space" = "cmp.mapping.complete()";
          "<Tab>" = {
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end
              end
            '';
            modes = [ "i" "s" ];
          };
        };
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
        # capabilities = ''
        #   local capabilities = require('cmp_nvim_lsp').default_capabilities()
        #   local lspconfig = require('lspconfig')
        #   lspconfig.nixd.setup {
        #       capabilities = capabilities
        #   }
        # '';
        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
        };
        servers = {
          nixd = {
            enable = true;
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
                  installable = "/flakeref#nixosConfigurations.squirtle.options";
                };
              };
            };
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
        };
      };
    };
  };
}

