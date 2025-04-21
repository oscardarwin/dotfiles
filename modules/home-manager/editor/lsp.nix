{ inputs, pkgs, ... }: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      incrementalSelection.enable = true;
      ensureInstalled = [ "nix" "bash" "c" "json" "xml" ];

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
        xml
      ];
    };

    rust-tools = {
      enable = true;
      server = {
        hover = {
          actions = {
            enable = true;
            debug.enable = true;
            gotoTypeDef.enable = true;
            implementations.enable = true;
            references.enable = true;
            run.enable = true;
          };
        };
      };
    };

    lsp-format = {
      enable = true;
      setup = {
        nix = {
          sync = true;
        };
        rust-analyzer = {
          sync = true;
        };
      };
    };
    lsp = {
      enable = true;

      servers = {
        nixd = {
          enable = true;
          rootDir = "";
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
        jsonls = {
          enable = true;
        };
        pyright = {
          enable = true;
        };
      };
    };
  };
}
