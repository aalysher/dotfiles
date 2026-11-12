local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local config_group = augroup('config_group', { clear = true })
local yank_group = augroup('HighlightYank', { clear = true })
local treesitter_group = augroup('TreesitterHighlight', { clear = true })

-- Native Treesitter highlight on buffer attach / filetype
autocmd('FileType', {
  group = treesitter_group,
  pattern = '*',
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- highlight on yank
autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

--- remove all trailing whitespace on save
autocmd('BufWritePre', {
  group = config_group,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- don't auto commenting new lines
autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    vim.opt.fo:remove('c')
    vim.opt.fo:remove('r')
    vim.opt.fo:remove('o')
  end,
})

-- 2 spaces for selected filetypes
autocmd('FileType', {
  pattern = 'xml,html,xhtml,css,scss,javascript,lua,yaml,htmljinja',
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})


