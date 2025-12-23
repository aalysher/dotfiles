return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" },
      { "<leader>ce", "<cmd>CopilotChatExplain<CR>", mode = "v", desc = "Explain code" },
      { "<leader>cr", "<cmd>CopilotChatReview<CR>", mode = "v", desc = "Review code" },
      { "<leader>cs", "<cmd>CopilotChatOptimize<CR>", mode = "v", desc = "Optimize code" },
      { "<leader>ct", "<cmd>CopilotChatTests<CR>", mode = "v", desc = "Generate tests" },
      { "<leader>cm", "<cmd>CopilotChatCommit<CR>", mode = "n", desc = "Generate commit message" },
      { "<leader>cv", "<cmd>CopilotChatCommit<CR>", mode = "v", desc = "Generate commit for selection" },
    },
  },
}
