return {
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup {
                direction = "float",
                float_opts = {
                    border = "curved",
                    width = math.floor(vim.o.columns * 0.9),
                    height = math.floor(vim.o.lines * 0.9),
                },
            }

            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "curved",
                },
            })

            function _lazygit_toggle()
                lazygit:toggle()
            end

            vim.api.nvim_set_keymap(
                "n",
                "<leader>lg",
                "<cmd>lua _lazygit_toggle()<CR>",
                { noremap = true, silent = true }
            )
        end
    }
}

