local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local ysomad_group = augroup('ysomad', {})
local yank_group = augroup('HighlightYank', {})
local statusline_group = augroup('StatusLine', {})
local go_group = augroup('GoSettings', {})

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
  group = ysomad_group,
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
  end
})

-- 2 spaces for selected filetypes
autocmd('FileType', {
  pattern = 'xml,html,xhtml,css,scss,javascript,lua,yaml,htmljinja',
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end
})

-- go: format and organize imports on save
autocmd('BufWritePre', {
  pattern = { '*.go' },
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })
    if #clients == 0 then
      return
    end

    -- Organize imports and format synchronously
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" } },
      apply = true,
    })
    
    vim.lsp.buf.format({ async = false })
  end
})

-- go: set workspace folder for better LSP support
autocmd('FileType', {
  group = go_group,
  pattern = 'go',
  callback = function()
    local root_dir = vim.fs.find({'go.mod', 'go.work', '.git'}, {
      upward = true,
      stop = vim.loop.os_homedir(),
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    })[1]                   

    if root_dir then
      vim.b.workspace_folder = vim.fs.dirname(root_dir)
    end
  end
})

-- custom statusline
autocmd({"WinEnter", "BufEnter"}, {
  group = statusline_group,
  pattern = "*",
  command = [[setlocal statusline=%!v:lua.require('ysomad.statusline').setup()]]
})
