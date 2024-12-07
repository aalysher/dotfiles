return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "leoluz/nvim-dap-go",
    "nvim-neotest/nvim-nio"
  },
  config = function ()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_go = require("dap-go")
    dap_go.setup({
      delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        build_flags = "-gcflags='all=-N -l'",
      },
    })

    dap.configurations.go = {
      {
        type = "go",
        name = "Debug Current Package",
        request = "launch",
        mode = "debug",
        program = "${fileDirname}",
        buildFlags = "-gcflags='all=-N -l'"
      },
      {
        type = "go",
        name = "Debug Main Package",
        request = "launch",
        mode = "debug",
        program = "${workspaceFolder}/cmd/main.go",
        buildFlags = "-gcflags='all=-N -l'"
      },
      {
        type = "go",
        name = "Debug Test",
        request = "launch",
        mode = "test",
        program = "${fileDirname}"
      }
    }

    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.keymap.set("n", "<F21>", dap.continue, { desc = "DAP continue" })
    vim.keymap.set("n", "<F8>", dap.step_over, { desc = "DAP step over" })
    vim.keymap.set("n", "<F9>", dap.step_out, { desc = "DAP step out" })
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP open REPL" })
    vim.keymap.set("n", "<leader>B", function ()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = "DAP set breakpoint with condition" })
    vim.keymap.set("n", "<leader>lp", function ()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, { desc = "DAP set breakpoint with log msg" })
  end
}
