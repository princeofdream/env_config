return {
    {
        "ntpeters/vim-better-whitespace",

        config = function()
            vim.keymap.set("n", "<leader>w",
                function()
                    vim.cmd("s/\\s\\+$//")
                end, {
                    unique = true,
                    desc = "Remove trailing whitespace"
                }
            )
            vim.keymap.set("n", "<leader>W",
                function()
                    vim.cmd("%s/\\s\\+$//")
                end, {
                    unique = true,
                    desc = "Remove trailing whitespace"
                }
            )

            vim.g.better_whitespace_enable_trailing_whitespace = 1
            vim.g.better_whitespace_enable_tabstops = 1
            vim.g.better_whitespace_enable_tabline = 1
            vim.g.better_whitespace_enable_tabline_tabstops = 1
            vim.g.better_whitespace_enabled=1
            vim.g.strip_whitespace_on_save=0
            vim.g.better_whitespace_ctermcolor='62'
            vim.g.better_whitespace_guicolor='#5f5fd7'
            vim.g.better_whitespace_guicolor_trailing='#5f5fd7'
            vim.g.better_whitespace_guicolor_tabstops='#5f5fd7'
            vim.g.strip_whitespace_confirm=1
        end,

    },
}

