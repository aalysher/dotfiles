-- return {
--   "kyazdani42/nvim-tree.lua",
--   requires = { "kyazdani42/nvim-web-devicons" },
--   config = function()
--     vim.g.loaded_netrw = 1
--     vim.g.loaded_netrwPlugin = 1
--     require("nvim-tree").setup({
--       filters = {
--         dotfiles = true,
--       }
--     })
--     vim.keymap.set("n", "<A-1>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle window" })
--   end
-- }

return {
  "kyazdani42/nvim-tree.lua",
  requires = { "kyazdani42/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
      filters = {
        dotfiles = true,
      },
      view = {
        side = "left",
        width = 30,
      },
    })

    local function is_nvim_tree_open()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_name(buf):match("NvimTree") then
          return true
        end
      end
      return false
    end

    local function toggle_tree()
      if is_nvim_tree_open() then
        vim.cmd("NvimTreeClose")
      else
        vim.cmd("NvimTreeOpen")
        vim.cmd("NvimTreeFindFile")
      end
    end

    vim.keymap.set("n", "<A-1>", toggle_tree, { desc = "Toggle NvimTree and focus on current file" })
  end
}

