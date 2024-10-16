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


opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = 'yes'
opt.isfname:append('@-@')

opt.updatetime = 50
opt.colorcolumn = '80'

vim.g.mapleader = ' '
vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true

-- Disable swap files
opt.swapfile = false

-- opt.guicursor = ""

opt.cursorline = true
