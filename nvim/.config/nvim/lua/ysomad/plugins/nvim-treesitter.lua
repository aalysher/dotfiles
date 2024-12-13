return {
  'nvim-treesitter/nvim-treesitter',
  priority = 1000,
  build = ':TSUpdate',
  config = function ()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'go', 'sql', 'json', 'yaml', 'lua', 'dockerfile' },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
