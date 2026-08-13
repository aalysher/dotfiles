-- vscode theme
-- return {
--   {
--     "Mofiqul/vscode.nvim",
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme("vscode")
--     end,
--   },
-- }

return {
  'maxmx03/solarized.nvim',
  lazy = false,
  priority = 1000,
  ---@type solarized.config
  opts = {},
  config = function(_, opts)
    vim.o.termguicolors = true
    vim.o.background = 'dark'
    require('solarized').setup(opts)
    vim.cmd.colorscheme 'solarized'
  end,
}
