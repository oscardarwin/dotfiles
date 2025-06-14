{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./auto-complete.nix
    ./lsp.nix
    # ./debugger.nix
    ./keybindings.nix
  ];

  programs.nixvim = {
    enable = true;

    nixpkgs.config.allowUnfree = true;

    opts = {
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
      colorcolumn = "0";
    };

    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true;
    clipboard.providers.xclip.enable = true;

    plugins = {
      image.enable = true;
      nvim-surround.enable = true;
      hardtime.enable = true;

      lsp-lines.enable = true;
      illuminate.enable = true;
      leap.enable = true;
      telescope = {
        enable = true;
        extensions = {
          undo.enable = true;
          manix.enable = true;
          ui-select.enable = true;
        };
      };
      web-devicons.enable = true;
      lualine = {
        enable = true;
        settings = {
          sections = {
            lualine_b = [{ __unkeyed-1 = "filename"; path = 1; }];
            lualine_c = [ "lsp_status" ];
            lualine_y = [ "diff" "diagnostics" ];
            lualine_z = [ "branch" ];
          };

        };
      };
      lilypond-suite = {

        enable = true;
        settings = {
          lilypond = {
            options = {
              include_dir = [
                "./openlilylib"
              ];
              output = "pdf";
              pitches_language = "default";
            };
          };
        };
      };
      gitsigns.enable = true;
      codecompanion = {
        enable = true;
        settings.adapters = {
          openai = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("openai", {
                  env = {
                    api_key = "cmd:op read op://personal/OpenAI/credential --no-newline --session \"$(systemctl --user show-environment | grep '^OP_SESSION=' | cut -d= -f2-)\"",
                  },
                })
              end
            '';
          };
        };
      };
      oil = {
        enable = true;
        settings.view_options.show_hidden = true;
      };
    };
  };
}
