return {
  "folke/noice.nvim",
  config = function()
    local noice = require("noice")

    noice.setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      messages = {
        enabled = true,
        view = "mini",
        view_error = "mini",
        view_warn = "mini",
        view_history = "mini",
        view_search = "mini",
      },
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        {
          view = "mini",
          filter = { event = "notify", not_find = "Comment" },
        },
        {
          view = "mini",
          filter = { event = "msg_showmode", find = "recording" },
        },
      },
    })
  end,
}

