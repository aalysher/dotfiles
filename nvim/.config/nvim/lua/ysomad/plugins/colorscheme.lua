-- vscode theme
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

-- return {
--   {
--     "shaunsingh/nord.nvim",
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme("nord")
--     end,
--   },
-- }

-- JetBrains dark theme
-- return {
--     "nickkadutskyi/jb.nvim",
--     lazy = false,
--     priority = 1000,
--     opts = {},
--     config = function()
--         -- require("jb").setup({transparent = true})
--         vim.cmd("colorscheme jb")
--     end,
-- }
