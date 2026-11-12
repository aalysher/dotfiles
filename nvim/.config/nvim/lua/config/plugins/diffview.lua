local ok, diffview = pcall(require, "diffview")
if not ok then return end

local actions = require("diffview.actions")

diffview.setup({
  enhanced_diff_hl = true, -- подсветка точных изменений внутри строки (word diff)
  use_icons = true,
  view = {
    default = {
      layout = "diff2_horizontal", -- 2-панельный side-by-side (как в GoLand)
      winbar_info = true,
    },
    merge_tool = {
      layout = "diff3_horizontal", -- 3-сторонний diff для merge-конфликтов
      disable_diagnostics = true,
      winbar_info = true,
    },
    file_history = {
      layout = "diff2_horizontal",
      winbar_info = true,
    },
  },
  file_panel = {
    listing_style = "tree", -- "tree" как Project/Commit view в GoLand или "list"
    win_config = {
      position = "left",
      width = 35,
    },
  },
  keymaps = {
    disable_defaults = false, -- сохраняем мощные дефолты плагина
    view = {
      { "n", "q",     "<cmd>DiffviewClose<CR>",          { desc = "Close diffview" } },
      { "n", "<Esc>", "<cmd>DiffviewClose<CR>",          { desc = "Close diffview" } },
      { "n", "[c",    actions.prev_conflict,             { desc = "Go to prev conflict" } },
      { "n", "]c",    actions.next_conflict,             { desc = "Go to next conflict" } },
      { "n", "<tab>", actions.select_next_entry,         { desc = "Open diff for next file" } },
      { "n", "<s-tab>", actions.select_prev_entry,       { desc = "Open diff for previous file" } },
      { "n", "<leader>e", actions.focus_files,           { desc = "Focus file panel" } },
      { "n", "<leader>b", actions.toggle_files,          { desc = "Toggle file panel" } },
    },
    file_panel = {
      { "n", "q",     "<cmd>DiffviewClose<CR>",          { desc = "Close diffview" } },
      { "n", "<Esc>", "<cmd>DiffviewClose<CR>",          { desc = "Close diffview" } },
      { "n", "<CR>",  actions.select_entry,              { desc = "Open diff for file" } },
      { "n", "o",     actions.select_entry,              { desc = "Open diff for file" } },
      { "n", "s",     actions.toggle_stage_entry,        { desc = "Stage / unstage file" } },
      { "n", "S",     actions.stage_all,                 { desc = "Stage all" } },
      { "n", "U",     actions.unstage_all,               { desc = "Unstage all" } },
      { "n", "X",     actions.restore_entry,             { desc = "Rollback / restore entry (discard changes)" } },
      { "n", "R",     actions.refresh_files,             { desc = "Refresh list" } },
      { "n", "i",     actions.listing_style,             { desc = "Toggle tree / list view" } },
      { "n", "<tab>", actions.select_next_entry,         { desc = "Next file" } },
      { "n", "<s-tab>", actions.select_prev_entry,       { desc = "Previous file" } },
      { "n", "<leader>e", actions.toggle_files,          { desc = "Toggle file panel" } },
    },
    file_history_panel = {
      { "n", "q",     "<cmd>DiffviewClose<CR>",          { desc = "Close file history" } },
      { "n", "<CR>",  actions.select_entry,              { desc = "Open diff for selected commit" } },
      { "n", "o",     actions.select_entry,              { desc = "Open diff for selected commit" } },
      { "n", "<tab>", actions.select_next_entry,         { desc = "Next file" } },
      { "n", "<s-tab>", actions.select_prev_entry,       { desc = "Previous file" } },
    },
  },
})

-- Удобные маппинги (аналог вкладок Local Changes / Log в GoLand)
-- Открыть обзор изменений текущей ветки / рабочей директории
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Diffview: Local changes (all files)" })

-- История коммитов текущего файла (GoLand: Show History)
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview: File history (current file)" })

-- История коммитов всего проекта / ветки (GoLand: Git Log)
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview: Branch / project history" })

-- Быстро закрыть Diffview
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<CR>", { desc = "Diffview: Close" })
