-- Git and version control plugins setup
return {
    -- Git gutter
    {
        "airblade/vim-gitgutter",
        config = function()
            vim.g.gitgutter_max_signs = 2048
        end,
    },

    -- Git wrapper
    {
        "tpope/vim-fugitive",
        config = function()
            vim.api.nvim_create_autocmd("QuickFixCmdPost", {
                pattern = "*grep*",
                callback = function()
                    vim.cmd("cwindow")
                end,
            })
        end,
    },

    -- Commit browser
    {
        "junegunn/gv.vim",
    },

    -- Gist client
    {
        "mattn/gist-vim",
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "契" },
                    topdelete = { text = "契" },
                    changedelete = { text = "▎" },
                },
            })
        end,
    },
    {
        "APZelos/blamer.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        event = "BufReadPost",  -- 在缓冲区读取后加载
        config = function()
            -- 配置 blamer.nvim
            vim.g.blamer_enabled = 1  -- 启用插件
            vim.g.blamer_delay = 1000  -- 设置延迟时间（毫秒）
            vim.g.blamer_show_in_visual_modes = false  -- 在可视模式中不显示
            vim.g.blamer_show_inserting = false  -- 在插入模式中不显示
            vim.g.blamer_prefix = ' > '  -- 设置前缀
            vim.g.blamer_template = '<author>, <author-time> • <summary>'  -- 设置显示模板
            vim.g.blamer_date_format = '%Y-%m-%d'  -- 设置日期格式
            
            -- 可选：添加切换功能的快捷键
            vim.keymap.set("n", "<leader>bt", "<cmd>BlamerToggle<cr>", { desc = "Toggle git blame" })
        end,
    },
}
