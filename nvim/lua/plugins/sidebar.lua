return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        keys = {
            { "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Tree" },
            { "<F2>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Tree" },
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
        end,
    },
    -- {
    --     "akinsho/bufferline.nvim",
    --     config = function()
    --         require("bufferline").setup({
    --             options = {
    --                 indicator = {
    --                     icon = "▎",
    --                 },
    --                 offsets = {
    --                     left = 1,
    --                     right = 1,
    --                 },
    --             },
    --         })
    --     end,
    -- },
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
    {
        "itchyny/lightline.vim",
        lazy = false,
        event = "VimEnter",
        config = function()
            vim.g.lightline = {
                colorscheme = 'one',
                separator = { left = '', right = '' },
                subseparator = { left = '', right = '' },
                active = {
                    left = {
                    { 'mode', 'paste' },
                    { 'gitbranch' },
                    { 'modified', 'readonly' },
                    { 'buffers' }
                    },
                    right = {
                    { 'lineinfo' },
                    { 'percent' },
                    { 'fileformat', 'fileencoding', 'filetype' }
                    }
                },
                inactive = {
                    left = { { 'filename' } },
                    right = { { 'lineinfo' }, { 'percent' } }
                },
                tabline = {
                    left = { { 'tabs' } },
                    right = { { 'close' } }
                },
                tab = {
                    active = { 'tabnum', 'filename', 'modified' },
                    inactive = { 'tabnum', 'filename', 'modified' }
                },
                component_function = {
                    gitbranch = 'FugitiveHead',
                    filestat = 'LightlineFilestat'
                },
            }
            vim.fn.LightlineFilestat = function()
                local filename = vim.fn.expand('%:t') ~= '' and vim.fn.expand('%:t') or '[No Name]'
                local modified = vim.bo.modified and ' +' or ''
                return filename .. modified
            end
        end
    }
}