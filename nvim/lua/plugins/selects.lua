return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate"
    },
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
    -- {
    --     "anuvyklack/pretty-fold.nvim",
    --     config = function()
    --         require('pretty-fold').setup()
    --     end,
    -- },
    {
        "chrisgrieser/nvim-origami",
        event = "VeryLazy",
        opts = {}, -- needed even when using default config

        -- recommended: disable vim's auto-folding
        init = function()
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end,
    },

}
