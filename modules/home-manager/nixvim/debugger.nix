{ pkgs, ... }: {
  home.packages = with pkgs; [
    lldb_18
  ];

  programs.nixvim = {
    plugins = {
      dap.enable = true;
      dap-virtual-text.enable = true;
      dap-ui.enable = true;
      dap-python.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      nvim-gdb
    ];

    keymaps = [
      {
        key = "qh";
        mode = "n";
        action = ":lua require'rust-tools'.hover_actions.hover_actions()";
        options = {
          silent = true;
          noremap = true;
          desc = "Open Hover Actions";
        };
      }
      {
        key = "qb";
        mode = "n";
        action = ":lua require'dap'.toggle_breakpoint()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Toggle DAP [b]reakpoint";
        };
      }
      {
        key = "qr";
        mode = "n";
        action = ":lua require'dap'.repl.open()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "[d]ap r[e]pl open";
        };
      }
      {
        key = "qc";
        mode = "n";
        action = ":lua require'dap'.continue()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Continue DAP debug";
        };
      }
      {
        key = "<qs>";
        mode = "n";
        action = ":lua require'dap'.step_over()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Step over DAP debug";
        };
      }
      {
        key = "<qi>";
        mode = "n";
        action = ":lua require'dap'.step_into()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Step into DAP debug";
        };
      }
      {
        key = "<qo>";
        mode = "n";
        action = ":lua require'dap'.step_out()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Stepout of DAP debug";
        };
      }
    ];
  };
}

