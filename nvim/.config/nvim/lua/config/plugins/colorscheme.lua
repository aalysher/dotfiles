-- тема как jetbrains goland
-- pcall(vim.cmd.colorscheme, "jb")

require("solarized-osaka").setup({
    style = "vivid",
    transparent = true,
})
vim.cmd.colorscheme("solarized-osaka")

-- Более заметная подсветка строки с курсором
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#0f474f" })
