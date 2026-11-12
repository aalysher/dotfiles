local opt = vim.opt

-- Ensure stdpath('data')/site is in packpath for vim.pack
local site_path = vim.fn.stdpath("data") .. "/site"
if not string.find(vim.o.packpath, site_path, 1, true) then
  vim.opt.packpath:prepend(site_path)
end

-- Line numbers
opt.nu = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- Search settings
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Appearance & UI
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")
opt.updatetime = 50
opt.colorcolumn = "121"
opt.cursorline = true
opt.cmdheight = 0
opt.laststatus = 3
opt.showmode = false
opt.winborder = "rounded"
opt.pumheight = 10
opt.pumblend = 10

-- General
vim.g.mapleader = " "
vim.o.clipboard = "unnamedplus"
opt.swapfile = false

-- Folding settings using native treesitter
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldenable = true

-- For floating cmdline and messages (Neovim 0.12+ UI2)
require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = {
      [""] = "msg",
      empty = "cmd",
      bufwrite = "msg",
      confirm = "cmd",
      emsg = "pager",
      echo = "msg",
      echomsg = "msg",
      echoerr = "pager",
      completion = "cmd",
      list_cmd = "pager",
      lua_error = "pager",
      lua_print = "msg",
      progress = "pager",
      rpc_error = "pager",
      quickfix = "msg",
      search_cmd = "cmd",
      search_count = "cmd",
      shell_cmd = "pager",
      shell_err = "pager",
      shell_out = "pager",
      shell_ret = "msg",
      undo = "msg",
      verbose = "pager",
      wildlist = "cmd",
      wmsg = "msg",
      typed_cmd = "cmd",
    },
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.3, timeout = 5000 },
    pager = { height = 0.5 },
  },
})

-- Diagnostic UI (craftzdog style)
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
    format = function(diagnostic)
      if diagnostic.code then
        return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source or "", diagnostic.code)
      end
      return string.format("%s (%s)", diagnostic.message, diagnostic.source or "")
    end,
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

