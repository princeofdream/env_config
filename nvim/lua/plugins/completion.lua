return {
    -- {
    -- "neoclide/coc.nvim",
    -- build = "yarn install --frozen-lockfile",
    -- dependencies = {
    --     "antoinemadec/FixCursorHold.nvim",
    --     "folke/neodev.nvim",
    -- },
    -- config = function()
    --     require("config.coc").setup()
    -- end,
    -- keys = {
    --     { "<leader>ca", "<Plug>(coc-codeaction)", desc = "Code action" },
    -- }
    -- }
    -- lua/plugins/completion.lua
    {
        "junegunn/fzf",
        build = "./install --all", -- 确保 fzf 二进制文件已安装
    },
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        config = function()
            -- 键位映射配置
            local map = vim.keymap.set

            -- Mapping selecting mappings
            map("n", "<leader><tab>", "<plug>(fzf-maps-n)")
            map("x", "<leader><tab>", "<plug>(fzf-maps-x)")
            map("o", "<leader><tab>", "<plug>(fzf-maps-o)")

            -- Insert mode completion
            map("i", "<c-x><c-k>", "<plug>(fzf-complete-word)")
            map("i", "<c-x><c-f>", "<plug>(fzf-complete-path)")
            map("i", "<c-x><c-j>", "<plug>(fzf-complete-file-ag)")
            map("i", "<c-x><c-l>", "<plug>(fzf-complete-line)")

            -- Advanced customization using autoload functions
            vim.api.nvim_set_keymap(
                "i",
                "<c-x><c-k>",
                "fzf#vim#complete#word({'left': '15%'})",
                { expr = true, noremap = true }
                )
        end,
    },

    -- lua/plugins/leaderf.lua
    {
        "Yggdroot/LeaderF",
        -- dependencies = { "Yggdroot/LeaderF-Coc" },
        keys = {
            { "<C-p>"     , "<cmd>Leaderf file<cr>", desc = "Find file" },
            { "<leader>ff", "<cmd>Leaderf file<cr>", desc = "Find file" },
            { "<leader>fg", "<cmd>Leaderf grep<cr>", desc = "Grep" },
            { "<leader>fb", "<cmd>Leaderf buffer<cr>", desc = "Buffer" },
            { "<leader>fh", "<cmd>Leaderf help_tags<cr>", desc = "Help tags" },
            { "<leader>fr", "<cmd>Leaderf resume<cr>", desc = "Resume" },
            { "<leader>fs", "<cmd>Leaderf grep_string<cr>", desc = "Grep string" },
            { "<leader>fu", "<cmd>Leaderf grep_lua<cr>", desc = "Grep lua" },
            { "<leader>fv", "<cmd>Leaderf grep_vim<cr>", desc = "Grep vim" },
            { "<leader>fj", "<cmd>Leaderf grep_json<cr>", desc = "Grep json" },
            { "<leader>fk", "<cmd>Leaderf grep_kotlin<cr>", desc = "Grep kotlin" },
            { "<leader>fz", "<cmd>Leaderf grep_zsh<cr>", desc = "Grep zsh" },
        },
    },
}
