return {
  'nvim-treesitter/nvim-treesitter',
  event = { "BufReadPre", "BufNewFile" },
  build = ':TSUpdate',
  config = function ()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'json',
        'yaml',
        'bash',
        'dockerfile',
        'vimdoc',
        'vim',
        'go',
        'lua',
        'python',
        'sql',
        'markdown',
        'markdown_inline'
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- indent = { enable = true },
    })
  end
}
