-- return {
--   'rose-pine/neovim',
--   config = function()
--     require("rose-pine").setup({
--       disable_background = true
--     })
--     vim.cmd.colorscheme("rose-pine")
--     color = color or "rose-pine"
--     vim.cmd.colorscheme(color)
--
--     vim.api.nvim_set_hl(3, "Normal", { bg = "none" })
--     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--   end
-- }

-- return {
--   {
--     "catppuccin/nvim",
--     lazy = false,
--     name = "catppuccin",
--     priority = 1000,
--     config = function()
--       -- require("catppuccin").setup({
--       --   flavor = "mocha",
--       --   background = { dark = "mocha" },
--       --   color_overrides = {
--       --     mocha = {
--       --       base = "#000000",
--       --       mantle = "#000000",
--       --       crust = "#000000",
--       --     },
--       --   },
--       -- })
--       vim.cmd.colorscheme "catppuccin-mocha"
--       -- vim.cmd.colorscheme "catppuccin"
--     end
--   }
-- }

-- return {
--   {
--     "p00f/alabaster.nvim",
--     priority = 1000, -- Ensure the theme loads first
--     config = function()
--       vim.cmd("colorscheme alabaster")
--     end,
--   },
-- }


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
--     priority = 1001,  -- выше чем у treesitter
--     dependencies = { 'nvim-treesitter/nvim-treesitter' },
--     config = function()
--       -- Отключаем semantic tokens для go
--       require('lspconfig').gopls.setup({
--         on_attach = function(client)
--           client.server_capabilities.semanticTokensProvider = nil
--         end
--       })
--
--       -- Устанавливаем нашу схему
--       require('goland').setup()
--     end,
--   },
-- }
