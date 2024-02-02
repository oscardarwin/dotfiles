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
    };

    colorscheme = lib.mkForce "tokyonight";
    colorschemes.tokyonight.enable = true;

    plugins = {
      lightline.enable = true;

      nvim-cmp = {
        enable = true;
        autoEnableSources = true;
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          # {name = "luasnip";}
        ];
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
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
      telescope.enable = true;
      lualine.enable = true;
      lsp-format = {
        enable = true;
        setup = {
          nix = {
            sync = true;
          };
        };
      };
      lsp = {
        enable = true;

        servers = {
          nixd = {
            enable = true;
            settings.formatting.command = "nixpkgs-fmt";
          };
        };
      };
    };
  };
}

