-- jetbrains darcula
-- return {
--   {
--     "xiantang/darcula-dark.nvim",
--     dependencies = {
--       "nvim-treesitter/nvim-treesitter",
--     },
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme("darcula-dark")
--     end,
--   },
-- }

-- vs-code like pictograms
return {
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("vscode")
    end,
  },
}

-- custom goland theme
-- return {
--   {
--     dir = "~/go/src/goland.nvim",
--     priority = 1000,
--     config = function()
--       require('goland').setup()
--     end,
--   },
-- }

