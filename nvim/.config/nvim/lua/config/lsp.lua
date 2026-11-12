local M = {}

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

-- Setup LSP Keymaps and Buffer Settings on Attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("ConfigLsp", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local opts = { buffer = bufnr, noremap = true, silent = true }

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
    vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Inlay Hints (if supported by server)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- IDE-like document highlight under cursor (buffer-local, debounced via CursorHold)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = highlight_group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = highlight_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- Capabilities for LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

-- Native Server Configurations (Neovim 0.11+)

-- Gopls
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  capabilities = capabilities,
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
        assignVariableTypes = true,
        compositeLiteralFields = true,
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
    },
  },
})

-- Lua Language Server
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

-- Bash Language Server
vim.lsp.config("bashls", {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  root_markers = { ".git" },
  capabilities = capabilities,
})

-- Docker Language Server
vim.lsp.config("dockerls", {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile", ".git" },
  capabilities = capabilities,
})

-- Docker Compose Language Service
vim.lsp.config("docker_compose_language_service", {
  cmd = { "docker-compose-langserver", "--stdio" },
  filetypes = { "yaml.docker-compose" },
  root_markers = { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml", ".git" },
  capabilities = capabilities,
})

-- YAML Language Server
vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_markers = { ".git" },
  capabilities = capabilities,
})

-- Enable all configured servers
vim.lsp.enable({
  "gopls",
  "lua_ls",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "yamlls",
})

-- go: format and organize imports on save (belongs with LSP config)
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('GoLspFormat', { clear = true }),
  pattern = { '*.go' },
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = 'gopls' })
    if #clients == 0 then return end
    vim.lsp.buf.code_action({
      context = { only = { 'source.organizeImports' } },
      apply = true,
    })
    vim.lsp.buf.format({ async = false })
  end,
})

return M
