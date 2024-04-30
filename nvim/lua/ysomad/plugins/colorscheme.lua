return {
  'rose-pine/neovim',
  config = function()
    require("rose-pine").setup({
      disable_background = true
    })
    vim.cmd.colorscheme("rose-pine")
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(3, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end
}
