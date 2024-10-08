return {
  'numToStr/Comment.nvim',
  event = {'BufReadPre', 'BufNewFile'},
  config = function()
    require('Comment').setup()

    -- Маппинги для комментирования
    vim.keymap.set("n", "<C-/>", function()
      require("Comment.api").toggle.linewise.current()
    end, { desc = "Comment Toggle" })

    vim.keymap.set(
      "v",
      "<C-_>",
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      { desc = "Comment Toggle" }
    )
  end
}
