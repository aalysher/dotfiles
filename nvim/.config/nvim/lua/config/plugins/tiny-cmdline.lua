local ok, tiny_cmdline = pcall(require, "tiny-cmdline")
if not ok then return end

tiny_cmdline.setup({
  width = {
    value = "55%",
    min = 40,
    max = 80,
  },
  position = {
    x = "50%",
    y = "25%",
  },
  border = "rounded",
  menu_col_offset = 3,
  native_types = { "/", "?" },
  title = {
    enabled = true,
    pos = "center",
  },
})

-- Distinct styling so the floating prompt has an opaque background with clean borders
local function setup_highlights()
  vim.api.nvim_set_hl(0, "TinyCmdlineNormal", { bg = "#001e26", fg = "#a0b4b6" })
  vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { fg = "#34c5b9", bg = "#001e26" })
  vim.api.nvim_set_hl(0, "TinyCmdlineTitle", { fg = "#5aaefa", bg = "#001e26", bold = true })
end

setup_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_highlights,
})
