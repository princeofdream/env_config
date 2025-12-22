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
            vim.keymap.set('n', 'tt', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', 'ff', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', 'fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', 'fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', 'fv', builtin.git_branches, { desc = 'Telescope git_branches' })
            require('telescope').setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                        },
                    },
                    mappings = {
                        i = {
                            ["<C-d>"] = "delete_buffer",  -- 在插入模式下按 Ctrl+w 删除 buffer
                        },
                        n = {
                            ["<C-d>"] = "delete_buffer",  -- 在普通模式下按 Ctrl+w 删除 buffer
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
        -- config = function()
        --     vim.api.nvim_set_keymap(
        --         'n',
        --         'tt',
        --         ":lua require'telescope'.extensions.project.project{}<CR>",
        --         {noremap = true, silent = true}
        --     )
        -- end,
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
        config = function()
            vim.keymap.del('n', '<leader>is')
            vim.keymap.del('i', '<leader>is')
        end,
    },
    {
        "jakemason/ouroboros",
        config = function()
            require('ouroboros').setup({
                score_required_to_be_confident_match_is_found = 15,
                extension_preferences_table = {
                      -- Higher numbers are a heavier weight and thus preferred.
                      -- In the following, .c would prefer to open .h before .hpp
                      c = {h = 11, hpp = 10},
                      h = {c = 11, cpp = 10},
                      cpp = {hpp = 11, h = 10},
                      hpp = {cpp = 11, c = 10},

                      -- Ouroboros supports any combination of filetypes you like, simply
                      -- add them as desired:
                      -- myext = { myextsrc = 2, myextoldsrc = 1},
                      -- tpp = {hpp = 2, h = 1},
                      -- inl = {cpp = 3, hpp = 2, h = 1},
                      -- cu = {cuh = 3, hpp = 2, h = 1},
                      -- cuh = {cu = 1}
                },
                switch_to_open_pane_if_possible = true,
            })
            vim.g.ouroboros_debug = 0
        end,
    },
    {
        "WolfgangMehner/bash-support",
    },
    {
        "WolfgangMehner/c-support",
    },
    -- {
    --     "WolfgangMehner/git-support",
    -- },
    {
        "WolfgangMehner/vim-support",
    },
    {
        "WolfgangMehner/latex-support",
    },
    -- {
    --     "WolfgangMehner/perl-support",
    -- },
    {
        "WolfgangMehner/awk-support",
    },
    -- {
    --     "WolfgangMehner/verilog-support",
    -- },
}
