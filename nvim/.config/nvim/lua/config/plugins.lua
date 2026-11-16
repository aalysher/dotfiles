local gh = function(repo)
  return "https://github.com/" .. repo
end

-- Register and install plugins via native vim.pack
vim.pack.add({
  -- Treesitter Highlighting & Parsers
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

  -- Dependencies & UI
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-tree/nvim-web-devicons"),

  -- Colorschemes
  gh("craftzdog/solarized-osaka.nvim"),

  -- Fuzzy Finder (snacks.nvim)
  gh("folke/snacks.nvim"),

  -- UI Enhancements
  gh("rachartier/tiny-cmdline.nvim"),
  gh("nvim-lualine/lualine.nvim"),

  -- Navigation & Git
  { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
  gh("lewis6991/gitsigns.nvim"),
  gh("sindrets/diffview.nvim"),
  gh("christoomey/vim-tmux-navigator"),
  gh("folke/which-key.nvim"),
}, { confirm = false })

-- Load and configure each plugin module
require("config.plugins.treesitter")
require("config.plugins.colorscheme")
require("config.plugins.snacks")
require("config.plugins.harpoon")
require("config.plugins.gitsigns")
require("config.plugins.diffview")
require("config.plugins.which-key")
require("config.plugins.tiny-cmdline")
require("config.plugins.lualine")
