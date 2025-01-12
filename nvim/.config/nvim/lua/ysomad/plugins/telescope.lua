return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    'nvim-telescope/telescope-ui-select.nvim',
  },
  config = function ()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require('telescope.builtin')

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        buffers = {
          sort_mru = true,
          mappings = {
            i = {
             ["<C-d>"] = "delete_buffer",
            }
          }
        }
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({
          })
        }
      }
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope Find files" })
    vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live grep" })
    vim.keymap.set(
      "n",
      "<leader>fa",
      "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
      { desc = "Telescope Find all files" }
    )

    vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Fuzzy find git files" })
    vim.keymap.set('n', '<leader>fb', function()
      builtin.buffers({sort_mru=true, ignore_current_buffer=true})
    end, { desc = "List opened buffers" })
    vim.keymap.set('n', '<leader>fg', function()
      builtin.grep_string({ search = vim.fn.input('Grep > ') });
    end, { desc = "Grep string" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "List help tags" })
    vim.keymap.set('n', '<leader>fx', builtin.treesitter, { desc = "List tresitter funcs, vars"})
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
  end
}


