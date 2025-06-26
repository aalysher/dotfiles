local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp"
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr

      opts.desc = "Show LSP references"
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

      opts.desc = "Go to declaration"
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Show LSP definitions"
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

      opts.desc = "Show LSP implementations"
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

      opts.desc = "Show LSP type definitions"
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

      opts.desc = "See available code actions"
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Smart rename"
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "Show buffer diagnostics"
      vim.keymap.set("n", "<leader>D", vim.diagnostic.setqflist, opts)

      opts.desc = "Lsp diagnostic loclist"
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

      opts.desc = "Show line diagnostics"
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

      opts.desc = "Prev diagnostic"
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

      opts.desc = "Next diagnostic"
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

      opts.desc = "Next error"
      vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), opts)

      opts.desc = "Prev error"
      vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), opts)

      opts.desc = "Next warning"
      vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), opts)

      opts.desc = "Prev warning"
      vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), opts)

      opts.desc = "Show documentation for what is under cursor"
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

      opts.desc = "Restart LSP"
      vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
    end

    -- Enhanced capabilities for LSP
    local capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { "documentation", "detail", "additionalTextEdits" }
    }

    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern("go.mod", "go.work", ".git"),
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      offset_encoding = "utf-16",
      settings = {
        gopls = {
          directoryFilters = { "-.git", "-node_modules" },
          analyses = {
            unusedparams = true,
            unusedvariable = true,
            unusedwrite = true,
            fieldalignment = false,
            nilness = true,
            useany = true,
            shadow = true,
          },
          codelenses = {
            generate = true,
            run_govulncheck = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = false,
            compositeLiteralFields = false,
            compositeLiteralTypes = false,
            constantValues = false,
            functionTypeParameters = false,
            parameterNames = false,
            rangeVariableTypes = false,
          },
          staticcheck = true,
          gofumpt = true,
          semanticTokens = true,
          usePlaceholders = true,
          completeUnimported = true,
          deepCompletion = true,
          matcher = "Fuzzy",
          experimentalPostfixCompletions = true,
          buildFlags = { "-tags", "integration" },
        },
      },
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    lspconfig["bashls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
