local opt = vim.opt -- as a shorthand

-- disable the startup splash screen
-- opt.shortmess:append("I")

opt.nu = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true
opt.wrap = false


opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = 'yes'
opt.isfname:append('@-@')

opt.updatetime = 50
opt.colorcolumn = '121'

vim.g.mapleader = ' '
vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true

-- Disable swap files
opt.swapfile = false

-- opt.guicursor = ""

opt.cursorline = true


-- Устанавливаем метод сворачивания для синтаксических блоков
vim.o.foldmethod = "syntax"
vim.o.foldlevel = 99  -- Показывает все уровни (для автоматического раскрытия можно изменить)
vim.o.foldenable = true  -- Включает сворачивание при запуске

-- Если требуется более гибкое сворачивание, можно использовать метод expr
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"  -- Используем Tree-sitter для более точного сворачивания

