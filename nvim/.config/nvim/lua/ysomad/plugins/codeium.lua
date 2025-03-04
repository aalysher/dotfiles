return {
  "Exafunction/codeium.vim",
  event = 'BufEnter',
  config = function()
    vim.g.codeium_anthropic_api_key = os.getenv("ANTHROPIC_API_KEY")
    vim.g.codeium_model = 'claude-3-7-sonnet-20250219'
    vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true, desc = "Codeium Accept" })
    vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true, desc = "Codeium Clear" })
    vim.keymap.set('i', '<C-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true, desc = "Codeium Cycle Completions Next" })
  end
}
