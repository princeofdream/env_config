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
    {
        'dense-analysis/ale',
        -- keys = {
        --     {
        --         "[v",
        --         function()
        --             vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(ale_previous_wrap)", true, true, true))
        --         end,
        --         mode = "n",
        --         desc = "ALE next wrap",
        --     },
        --     {
        --         "]v",
        --         function()
        --             vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(ale_next_wrap)", true, true, true))
        --         end,
        --         mode = "n",
        --         desc = "ALE next wrap",
        --     },
        -- },
        config = function()
            vim.g.ale_sign_column_always = 1
            vim.g.ale_set_highlights = 1


            -- 自定义错误和警告的显示文本
            vim.g.ale_echo_msg_error_str = '✗'  -- 错误符号
            vim.g.ale_echo_msg_warning_str = '⚠'  -- 警告符号
            vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'

            vim.g.ale_sign_error = '✗'
            vim.g.ale_sign_warning = '⚠'
            vim.g.ale_statusline_format = {'✗ %d', '⚠ %d', '✔ OK'}
            -- vim.g.ale_statusline_format = {'%d error(s)', '%d warning(s)', 'OK'}

            vim.g.ale_ruby_rubocop_auto_correct_all = 1
            vim.g.ale_keep_list_window_open = 1
            vim.g.ale_completion_enabled = 0
            vim.g.ale_set_loclist = 0
            vim.g.ale_set_quickfix = 1
            vim.g.ale_set_loclist_kind = 0
            vim.g.ale_keep_list_window_open = 1

            vim.g.ale_linters = {
                ruby = {'rubocop', 'ruby'},
                lua = {'lua_language_server'},
                python = {'flake8'},
                javascript = {'eslint'},
            }
            vim.g.ale_fixers = {
                ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
                python = {'autopep8', 'isort'},
            }

            vim.keymap.set("n", "]v",
                function()
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(ale_next_wrap)", true, true, true))
                end, { desc = "ALE next wrap" }
            )
            
            -- 可以添加更多键映射
            vim.keymap.set("n", "[v",
                function()
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(ale_previous_wrap)", true, true, true))
                end, { desc = "ALE previous wrap" }
            )
        end,
    },
}

