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
    local on_attach = function(_client, bufnr)
      opts.buffer = bufnr

      -- Настройка semantic tokens для gopls
      if _client.name == 'gopls' then
        _client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = {
              'namespace', 'type', 'class', 'enum', 'interface', 'struct',
              'typeParameter', 'parameter', 'variable', 'property', 'enumMember',
              'event', 'function', 'method', 'macro', 'keyword', 'modifier',
              'comment', 'string', 'number', 'regexp', 'operator', 'decorator'
            },
            tokenModifiers = {
              'declaration', 'definition', 'readonly', 'static', 'deprecated',
              'abstract', 'async', 'modification', 'documentation', 'defaultLibrary'
            }
          },
          range = true
        }
      end

      local builtin = require("telescope.builtin")

      opts.desc = "Show LSP references"
      vim.keymap.set("n", "gr", builtin.lsp_references, opts)

      opts.desc = "Go to declaration"
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Show LSP definitions"
      vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)

      opts.desc = "Show LSP implementations"
      vim.keymap.set("n", "gi", builtin.lsp_implementations, opts)

      opts.desc = "Show LSP type definitions"
      vim.keymap.set("n", "gt", builtin.lsp_type_definitions, opts)

      opts.desc = "See available code actions"
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Smart rename"
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "Show buffer diagnostics"
      vim.keymap.set("n", "<leader>D", builtin.diagnostics, opts)

      opts.desc = "Lsp diagnostic loclist"
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts) -- исправлена опечатка otps -> opts

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

    -- Расширенные capabilities для LSP
    local capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities.textDocument.semanticTokens = {
      dynamicRegistration = false,
      formats = { "relative" },
      multilineTokenSupport = false,
      overlappingTokenSupport = false,
      requests = {
        full = {
          delta = true
        },
        range = false
      },
      tokenModifiers = {},
      tokenTypes = {}
    }

    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
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
          },
          codelenses = {
            generate = true,
            run_govulncheck = true,
            tidy = true,
            upgrade_dependency = true,
          },
          hints = {
            constantValues = true
          },
          staticcheck = true,
          gofumpt = true,
          semanticTokens = true
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
