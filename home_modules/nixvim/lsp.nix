{ inputs, pkgs, ... }: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      settings = {
        incremental_selection.enable = true;
        ensure_installed = [ "nix" "bash" "c" "json" "xml" "wgsl" ];
      };

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.passthru.builtGrammars; [
        bash
        c
        html
        javascript
        latex
        lua
        nix
        python
        rust
        vimdoc
        xml
        wgsl
        yaml
      ];
    };

    rustaceanvim.enable = true;

    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          rust = [ "rustfmt" ];
          nix = [ "nixpkgs-fmt" ];
          javascript = [ "prettierd" ];
        };
        default_format_opts.lsp_format = "fallback";
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };
      };
    };
    lsp = {
      enable = true;

      servers = {
        nixd = {
          enable = true;
          rootMarkers = [ "flake.nix" ];
          settings = {
            eval.workers = 3;
            formatting.command = [ "nixpkgs-fmt" ];
            nixpkgs.expr = "import <nixpkgs> { }";
            options = {
              nixos = {
                expr = "(builtins.getFlake \"${inputs.self}\").nixosConfigurations.squirtle.options";
              };
              home_manager = {
                expr = "(builtins.getFlake \"${inputs.self}\").homeConfigurations.ghastly.options";
              };
            };
          };
        };
        bashls = {
          enable = true;
          filetypes = [ "sh" ];
        };
        jsonls.enable = true;
        pyright.enable = true;
        marksman.enable = true;
        ts_ls.enable = true;
      };
    };
  };
}
