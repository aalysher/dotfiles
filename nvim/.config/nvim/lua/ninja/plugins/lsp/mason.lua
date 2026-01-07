return {
  'williamboman/mason.nvim',
  priority = 1000,
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
        "delve", -- go debugger
        "gofumpt", -- go better gofmt
        { "gotests", branch = "develop" }, -- go tests codegen
        "golangci-lint",
      }
    })
  end
}
