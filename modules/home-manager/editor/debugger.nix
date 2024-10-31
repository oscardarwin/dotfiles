{ pkgs, ... }: {
  programs.nixvim = {
    plugins.dap = {
      enable = true;
      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
        dap-go.enable = true;
        dap-python.enable = true;
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
            command = '${pkgs.lldb_17}/bin/lldb-vscode', -- adjust as needed, must be absolute path
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
        key = "<leader>b";
        mode = "n";
        action = ":lua require'dap'.toggle_breakpoint()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Toggle DAP [b]reakpoint";
        };
      }
      {
        key = "<leader>B";
        mode = "n";
        action = ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Set DAP [B]reakpoint";
        };
      }
      {
        key = "<leader>de";
        mode = "n";
        action = ":lua require'dap'.repl.open()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "[d]ap r[e]pl open";
        };
      }
      {
        key = "<leader>lp";
        mode = "n";
        action = ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "[l]og DAP [p]oint message";
        };
      }
      {
        key = "<F5>";
        mode = "n";
        action = ":lua require'dap'.continue()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Continue DAP debug";
        };
      }
      {
        key = "<F10>";
        mode = "n";
        action = ":lua require'dap'.step_over()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Step over DAP debug";
        };
      }
      {
        key = "<F11>";
        mode = "n";
        action = ":lua require'dap'.step_into()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Step into DAP debug";
        };
      }
      {
        key = "<F12>";
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

