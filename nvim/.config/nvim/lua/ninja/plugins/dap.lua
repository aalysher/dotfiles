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

    -- Find main.go in common locations
    local function find_main_go()
      local workspace_root = vim.fn.getcwd()
      local common_paths = {
        workspace_root .. "/main.go",
        workspace_root .. "/cmd/main.go",
        workspace_root .. "/cmd/*/main.go",
        workspace_root .. "/app/main.go",
        workspace_root .. "/src/main.go",
      }

      for _, path in ipairs(common_paths) do
        if string.match(path, "%*") then
          -- Handle wildcard patterns for cmd/*/main.go
          local cmd_dir = workspace_root .. "/cmd"
          if vim.fn.isdirectory(cmd_dir) == 1 then
            local handle = vim.loop.fs_scandir(cmd_dir)
            if handle then
              while true do
                local name, type = vim.loop.fs_scandir_next(handle)
                if not name then break end
                if type == "directory" then
                  local main_path = cmd_dir .. "/" .. name .. "/main.go"
                  if vim.fn.filereadable(main_path) == 1 then
                    return main_path
                  end
                end
              end
            end
          end
        else
          if vim.fn.filereadable(path) == 1 then
            return path
          end
        end
      end
      return nil
    end

    -- Smart debug function that automatically chooses configuration
    local function smart_debug()
      local current_file = vim.fn.expand('%:p')
      local current_dir = vim.fn.expand('%:p:h')
      local workspace_root = vim.fn.getcwd()

      -- Check if current file is a test file
      if string.match(current_file, "_test%.go$") then
        dap.run({
          type = "go",
          name = "Debug Test",
          request = "launch",
          mode = "test",
          program = current_dir,
          buildFlags = "-gcflags='all=-N -l'"
        })
        return
      end

      -- Try to find main.go
      local main_go_path = find_main_go()
      if main_go_path then
        local main_dir = vim.fn.fnamemodify(main_go_path, ":h")
        dap.run({
          type = "go",
          name = "Debug Main",
          request = "launch",
          mode = "debug",
          program = main_dir,
          buildFlags = "-gcflags='all=-N -l'"
        })
        return
      end

      -- Check if current file is main.go
      if string.match(current_file, "main%.go$") then
        dap.run({
          type = "go",
          name = "Debug Main",
          request = "launch",
          mode = "debug",
          program = current_dir,
          buildFlags = "-gcflags='all=-N -l'"
        })
        return
      end

      -- Check if go.mod exists to determine if it's a module root
      if vim.fn.filereadable(workspace_root .. "/go.mod") == 1 then
        dap.run({
          type = "go",
          name = "Debug Module",
          request = "launch",
          mode = "debug",
          program = workspace_root,
          buildFlags = "-gcflags='all=-N -l'"
        })
        return
      end

      -- Fallback: debug current package
      dap.run({
        type = "go",
        name = "Debug Current Package",
        request = "launch",
        mode = "debug",
        program = current_dir,
        buildFlags = "-gcflags='all=-N -l'"
      })
    end

    -- Keep original configurations for manual selection if needed
    dap.configurations.go = {
      {
        type = "go",
        name = "Debug Main",
        request = "launch",
        mode = "debug",
        program = "${workspaceFolder}",
        buildFlags = "-gcflags='all=-N -l'"
      },
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
        name = "Debug Test",
        request = "launch",
        mode = "test",
        program = "${fileDirname}",
        buildFlags = "-gcflags='all=-N -l'"
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

    -- Key mappings
    vim.keymap.set("n", "<F5>", smart_debug, { desc = "Smart Debug Go" })
    vim.keymap.set("n", "<F21>", dap.continue, { desc = "DAP continue" })
    vim.keymap.set("n", "<F8>", dap.step_over, { desc = "DAP step over" })
    vim.keymap.set("n", "<F9>", dap.step_out, { desc = "DAP step out" })
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP open REPL" })
    vim.keymap.set("n", "<leader>dc", function()
      vim.ui.select(
        vim.tbl_map(function(config) return config.name end, dap.configurations.go),
        { prompt = "Select debug configuration:" },
        function(choice)
          if choice then
            for _, config in ipairs(dap.configurations.go) do
              if config.name == choice then
                dap.run(config)
                break
              end
            end
          end
        end
      )
    end, { desc = "DAP choose configuration" })
    vim.keymap.set("n", "<leader>B", function ()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = "DAP set breakpoint with condition" })
    vim.keymap.set("n", "<leader>lp", function ()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, { desc = "DAP set breakpoint with log msg" })
  end
}
