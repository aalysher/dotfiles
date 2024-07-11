return {
  "kyazdani42/nvim-tree.lua",
  requires = { "kyazdani42/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
      filters = {
        dotfiles = true,
      }
    })
    vim.keymap.set("n", "<A-1>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle window" })
  end
}


