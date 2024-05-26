return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function ()
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = {
        'lua_ls',
        'bashls',
        'gopls',
        'dockerls',
        'docker_compose_language_service',
        'yamlls',
      },
      automatic_installation = true
    })

    require('mason-tool-installer').setup({
      ensure_installed = {
        "gofumpt", -- go better gofmt
        -- { "gotests", branch = "develop" }, -- go tests codegen
        "golangci-lint",
      }
    })
  end
}
