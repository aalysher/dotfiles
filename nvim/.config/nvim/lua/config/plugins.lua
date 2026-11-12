local gh = function(repo)
  return "https://github.com/" .. repo
end

-- Build hooks for plugins (e.g. telescope-fzf-native)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
      vim.system({ "make" }, { cwd = ev.data.path }):wait()
    end
  end,
})

-- Register and install plugins via native vim.pack
vim.pack.add({
  -- Treesitter Highlighting & Parsers
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

  -- Dependencies & UI
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-tree/nvim-web-devicons"),

  -- Colorschemes
  gh("craftzdog/solarized-osaka.nvim"),

  -- File Explorer
  gh("stevearc/oil.nvim"),

  -- Fuzzy Finder
  gh("nvim-telescope/telescope.nvim"),
  gh("nvim-telescope/telescope-fzf-native.nvim"),
  gh("nvim-telescope/telescope-ui-select.nvim"),

  -- UI Enhancements
  gh("rachartier/tiny-cmdline.nvim"),
  gh("nvim-lualine/lualine.nvim"),

  -- Navigation & Git
  { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
  gh("lewis6991/gitsigns.nvim"),
  gh("sindrets/diffview.nvim"),
  gh("akinsho/toggleterm.nvim"),
  gh("christoomey/vim-tmux-navigator"),
  gh("folke/which-key.nvim"),
}, { confirm = false })

-- Load and configure each plugin module
require("config.plugins.treesitter")
require("config.plugins.colorscheme")
require("config.plugins.oil")
require("config.plugins.telescope")
require("config.plugins.harpoon")
require("config.plugins.gitsigns")
require("config.plugins.diffview")
require("config.plugins.toggleterm")
require("config.plugins.which-key")
require("config.plugins.tiny-cmdline")
require("config.plugins.lualine")
