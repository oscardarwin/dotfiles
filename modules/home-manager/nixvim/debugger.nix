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
      rust-tools.server.hover.actions = {
        enable = true;
        debug.enable = true;
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      nvim-gdb
    ];

    extraConfigLua = ''
         local dap, dapui = require("dap"), require("dapui")
         dap.listeners.before.attach.dapui_config = function()
         	dapui.open()
         end
         dap.listeners.before.launch.dapui_config = function()
         	dapui.open()
         end
         dap.listeners.before.event_terminated.dapui_config = function()
         	dapui.close()
         end
         dap.listeners.before.event_exited.dapui_config = function()
         	dapui.close()
         end

        local dap = require('dap')
        dap.set_log_level('debug')

        dap.adapters.lldb = {
            type = 'executable',
            command = '${pkgs.lldb_18}/bin/lldb', -- adjust as needed, must be absolute path
            name = 'lldb'
        }

        local dap = require("dap")
        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "-i", "dap" }
        }

        local dap = require('dap')
        dap.configurations.rust = {
      	{
      		name = 'launch',
      		type = 'lldb',
      		request = 'launch',
      		program = function()
      			return vim.fn.input('path of the executable: ', vim.fn.getcwd() .. '/', 'file')
      		end,
      		cwd = "''${workspacefolder}",
      		stoponentry = false,
      		args = {},
      	},
      }
    '';
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

