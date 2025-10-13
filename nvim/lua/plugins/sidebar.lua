return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        keys = {
            { "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Tree" },
            { "<F2>", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle File Tree" },
            { "tf", "<cmd>:tabnew<cr>:NvimTreeToggle<cr>", desc = "Toggle File Tree" },
        },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- optionally enable 24-bit colour
            vim.opt.termguicolors = true
            require("nvim-tree").setup({
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
                git = {
                    enable = true,
                },
            })
            local api = require "nvim-tree.api"
            -- vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "▎" },
                },
            })
        end,
    },
    {
        "preservim/tagbar",
        keys = {
            { "<F3>", "<cmd>TagbarToggle<cr>", desc = "Toggle tagbar Tree" },
        }
    },
    {
        "mbbill/undotree",
        keys = {
            { "<F6>", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
        },
        config = function()
            vim.g.undotree_SetFocusWhenToggle=1
            vim.g.undotree_WindowLayout = 4
        end,
    },
}

