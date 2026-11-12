local ok, oil = pcall(require, "oil")
if not ok then return end

oil.setup({
  default_file_explorer = true, -- заменяет netrw (:Ex тоже через oil)
  view_options = {
    show_hidden = true, -- скрытые файлы видны по умолчанию
  },
  delete_to_trash = true,
  columns = { "icon" },
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  float = {
    padding = 2,
    max_width = 80,
    max_height = 30,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
  keymaps = {
    ["g?"]  = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["-"]   = "actions.parent",
    ["_"]   = "actions.open_cwd",
    ["`"]   = "actions.cd",
    ["gs"]  = "actions.change_sort",
    ["gx"]  = "actions.open_external",
    ["g."]  = "actions.toggle_hidden",
    ["q"]   = "actions.close",
    ["<Esc>"] = "actions.close",
  },
  use_default_keymaps = false,
})

-- Toggle float: Alt+1
vim.keymap.set("n", "<A-1>", function()
  oil.toggle_float()
end, { desc = "Oil: toggle float explorer" })
