return {
    -- {
    --     "sustech-data/wildfire.nvim",
    --     event = "VeryLazy",
    --     dependencies = { "nvim-treesitter/nvim-treesitter" },
    --     config = function()
    --         require("wildfire").setup({
    --         surrounds = {
    --             { "(", ")" },
    --             { "{", "}" },
    --             { "[", "]" },
    --             { "<", ">" },
    --             { '"', '"' },
    --             { "'", "'" },
    --             { "`", "`" },
    --         },
    --     })
    --     end,
    -- },
    {
        "gcmt/wildfire.vim",
        event = "VeryLazy",
        config = function()
            vim.g.wildfire_surrounds = {
                { "(", ")" },
                { "{", "}" },
                { "[", "]" },
                { "<", ">" },
                { '"', '"' },
                { "'", "'" },
                { "`", "`" },
            }
        end,
        keys = {
            {
                "<SPACE>",
                function()
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(wildfire-fuel)", true, true, true))
                end,
                mode = { "n", "v" },
                desc = "Wildfire select next",
            },
            {
                "<C-SPACE>",
                function()
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(wildfire-water)", true, true, true))
                end,
                mode = "v",
                desc = "Wildfire select previous",
            },
        },
    },
}