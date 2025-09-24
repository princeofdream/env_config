return {
    {
        "danro/rename.vim",
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        -- keys = {
        --     { "ff", ":Telescope find_files<CR>", desc = "Find related files" },
        -- },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', 'tg', ":tabnew<CR>:Telescope find_files<CR>", { desc = 'New Tab' })
            vim.keymap.set('n', 'ff', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', 'fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', 'fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', 'fh', builtin.help_tags, { desc = 'Telescope help tags' })
            require('telescope').setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                        },
                    },
                },
            }
        end
    },
    {
        'nvim-telescope/telescope-project.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            vim.api.nvim_set_keymap(
                'n',
                'tt',
                ":lua require'telescope'.extensions.project.project{}<CR>",
                {noremap = true, silent = true}
            )
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                icons = true,
            }
        end,
    },
    {
        "vim-scripts/a.vim",
    },

    {
        "WolfgangMehner/bash-support",
    },
    {
        "WolfgangMehner/c-support",
    },
    {
        "WolfgangMehner/git-support",
    },
    {
        "WolfgangMehner/vim-support",
    },
    {
        "WolfgangMehner/latex-support",
    },
    {
        "WolfgangMehner/perl-support",
    },
    {
        "WolfgangMehner/awk-support",
    },
    {
        "WolfgangMehner/python-support",
    },
    {
        "WolfgangMehner/verilog-support",
    },
}
