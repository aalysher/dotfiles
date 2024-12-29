return {
  'numToStr/Comment.nvim',
  event = {'BufReadPre', 'BufNewFile'},
  config = function()
    require('Comment').setup()

    -- Маппинги для комментирования
    vim.keymap.set("n", "<C-_>", function()
      require("Comment.api").toggle.linewise.current()
    end, { desc = "Comment Toggle", noremap = true, silent = true })

    vim.keymap.set(
      "v",
      "<C-_>",
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      { desc = "Comment Toggle", noremap = true, silent = true }
    )
  end
}
