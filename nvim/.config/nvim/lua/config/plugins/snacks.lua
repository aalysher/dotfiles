local ok, Snacks = pcall(require, "snacks")
if not ok then return end

Snacks.setup({
  -- модуль explorer: заменяет netrw (:Ex), удаление в системную корзину (gio)
  explorer = { enabled = true },
  -- fuzzy finder
  picker = {
    enabled = true,
    ui_select = true, -- замена vim.ui.select (как telescope-ui-select)
    sources = {
      explorer = {
        hidden = true, -- скрытые файлы показывать по умолчанию (как в oil)
        -- (клавиша H внутри explorer всё ещё прячет/показывает их)
      },
    },
    -- <C-j>/<C-k>, <C-q>, Tab (мультивыбор) уже настроены по умолчанию
  },
  -- стартовый экран
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { -- вместо дефолтной "startup" (она требует lazy.nvim, которого нет)
        function()
          local ms = math.floor(vim.uv.uptime() * 100 + 0.5) / 100
          return {
            align = "center",
            text = {
              { "⚡ Neovim loaded in ", hl = "footer" },
              { ms .. "ms", hl = "special" },
            },
          }
        end,
      },
    },
  },
  -- всплывающие уведомления vim.notify
  notifier = { enabled = true },
  -- красивая колонка статуса (номера, git, folding)
  statuscolumn = { enabled = true },

  -- QoL-модули
  bigfile = { enabled = true },   -- большие файлы без syntax (не подвешивает nvim)
  indent = { enabled = true },    -- индент-гайды + подсветка текущего scope
  input = { enabled = true },     -- плавающие окна ввода (vim.ui.input)
  quickfile = { enabled = true }, -- мгновенное открытие файлов при старте
  scroll = { enabled = true },    -- плавный скроллинг
  words = { enabled = true },     -- подсветка вхождений слова под курсором (LSP)

  lazygit = { enabled = true },   -- плавающий lazygit
  rename = { enabled = true },    -- переименование файла с обновлением импортов (LSP)
  zen = { enabled = true },       -- zen-режим (скрыть UI, сфокусироваться на коде)
})

-- === Keymaps (соответствуют старым telescope) ===

vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fw", function() Snacks.picker.grep() end, { desc = "Live grep" })
vim.keymap.set(
  "n",
  "<leader>fa",
  function() Snacks.picker.files({ follow = true, hidden = true, ignored = true }) end,
  { desc = "Find all files" }
)
vim.keymap.set("n", "<C-p>", function() Snacks.picker.git_files() end, { desc = "Fuzzy find git files" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "List opened buffers" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep_word() end, { desc = "Grep string" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "List help tags" })
vim.keymap.set("n", "<leader>fx", function() Snacks.picker.lsp_symbols() end, { desc = "List symbols" })
-- файловый менеджер в сайдбаре (клавиша как был oil)
vim.keymap.set("n", "<A-1>", function() Snacks.picker.explorer() end, { desc = "File explorer" })
-- плавающий lazygit
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Toggle Lazygit" })
-- переименовать текущий файл (обновит импорты через LSP)
vim.keymap.set("n", "<leader>rf", function() Snacks.rename.rename_file() end, { desc = "Rename file (LSP)" })
-- zen mode / зум окна
vim.keymap.set("n", "<leader>z", function() Snacks.zen() end, { desc = "Zen mode" })
vim.keymap.set("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Zoom window" })
