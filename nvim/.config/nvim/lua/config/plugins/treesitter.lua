local ok, ts = pcall(require, "nvim-treesitter.configs")
if ok then
  ts.setup({
    ensure_installed = {
      "go",
      "sql",
      "json",
      "yaml",
      "lua",
      "dockerfile",
      "bash",
      "markdown",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  })
end
