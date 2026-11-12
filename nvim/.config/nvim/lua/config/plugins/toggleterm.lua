local ok, toggleterm = pcall(require, "toggleterm")
if not ok then return end

toggleterm.setup({
  direction = "float",
  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.9),
  },
})

local ok_term, term_mod = pcall(require, "toggleterm.terminal")
if ok_term then
  local lazygit = term_mod.Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "curved",
    },
  })

  vim.keymap.set("n", "<leader>lg", function()
    lazygit:toggle()
  end, { noremap = true, silent = true, desc = "Toggle Lazygit" })
end
