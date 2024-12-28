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

