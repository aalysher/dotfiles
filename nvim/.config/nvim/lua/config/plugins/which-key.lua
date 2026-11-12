vim.o.timeout = true
vim.o.timeoutlen = 300

local ok, wk = pcall(require, "which-key")
if ok then
  wk.setup({})
end
