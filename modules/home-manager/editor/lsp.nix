{ pkgs, ... }: {
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
        check.targets = "clippy";
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
          settings.formatting.command = [ "nixpkgs-fmt" ];
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
        pylsp = {
          enable = true;
        };
      };
    };
  };
}
