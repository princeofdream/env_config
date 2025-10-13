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
        config = function()
            -- vim.g.ale_sign_column_always = 1
            -- vim.g.ale_set_highlights = 1

            -- 自定义错误和警告的显示文本
            vim.g.ale_echo_msg_error_str = '✗'  -- 错误符号
            vim.g.ale_echo_msg_warning_str = '⚠'  -- 警告符号
            vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'

            vim.g.ale_use_neovim_diagnostics_api=0
            vim.g.ale_sign_error = '✗'
            vim.g.ale_sign_warning = '⚠'
            vim.g.ale_statusline_format = {'✗ %d', '⚠ %d', '✔ OK'}
            vim.g.ale_statusline_format = {'%d error(s)', '%d warning(s)', 'OK'}

            vim.g.ale_ruby_rubocop_auto_correct_all = 1
            vim.g.ale_keep_list_window_open = 1
            vim.g.ale_completion_enabled = 0
            vim.g.ale_set_loclist = 0
            vim.g.ale_set_quickfix = 1
            vim.g.ale_set_loclist_kind = 0
            vim.g.ale_keep_list_window_open = 1

            -- ALE Config
            vim.g.ale_linters = {
                c = {'gcc'},
                cpp = {'clang'},
                python = {'flake8', 'mypy', 'pylint'},
                sh = {'shellcheck'},
                lua = {'luacheck'},
                -- javascript = {'eslint'},
                -- typescript = {'eslint'},
                -- typescriptreact = {'eslint'},
            }

            local common_options = '-std=c14 -Wno-undef -Wextra -Wno-unused-but-set-variable \
                -I./include -I./src/include -I./source/include -I./parser/'

            vim.g.ale_c_gcc_options     = common_options
            vim.g.ale_c_clang_options   = common_options
            vim.g.ale_cpp_gcc_options   = common_options
            vim.g.ale_cpp_clang_options = common_options

            vim.g.ale_fixers = {
                c = {'gcc'},
                cpp = {'clang'},
                ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
                python = {'autopep8', 'isort'},
            }

            vim.keymap.set("n", "]v",
                function()
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(ale_next_wrap)", true, true, true))
                end, { desc = "ALE next wrap" }
            )
            vim.keymap.set("n", "[v",
                function()
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(ale_previous_wrap)", true, true, true))
                end, { desc = "ALE previous wrap" }
            )
            -- vim.cmd("ALEDisable")
        end,
    },
    {
        'Vonr/align.nvim',
        branch = "v2",
        lazy = true,
        init = function()
            local NS = { noremap = true, silent = true }

            -- vim.keymap.set(
            --     'x',
            --     '<leader>,',
            --     function()
            --         require'align'.align_to_char({
            --             length = 1,
            --         })
            --     end,
            --     NS
            -- )
            -- Aligns to a string with previews
            vim.keymap.set(
                'x',
                '<leader>=',
                function()
                    require'align'.align_to_string({
                        preview = true,
                        regex = false,
                    })
                end,
                NS
            )
            -- Example gawip to align a paragraph to a string with previews
            -- vim.keymap.set(
            --     'n',
            --     '<leader>]',
            --     function()
            --         local a = require'align'
            --         a.operator(
            --             a.align_to_string,
            --             {
            --                 regex = false,
            --                 preview = true,
            --             }
            --         )
            --     end,
            --     NS
            -- )

        end
    },
    {
        "davidhalter/jedi-vim",
        config = function()
            -- 禁用jedi-vim的文档快捷键
            vim.g["jedi#documentation_command"] = ""
            vim.g["jede#use_tabs_not_buffers"] = 1
            vim.g["jede#show_call_signatures"] = "1"
            vim.g["jede#popup_on_dot"] = 1
            vim.g["jede#popup_select_first"] = 0
            vim.g["jede#auto_initialization"] = 1
            vim.g["jede#goto_command"] = "<leader>j"
            vim.g["jede#goto_assignments_command"] = "<leader>J"
            vim.g["jede#goto_definition_command"] = "<leader>gd"
            vim.g["jede#goto_definition_split_command"] = "<leader>gD"
            vim.g["jede#goto_definition_tab_command"] = "<leader>gt"
            vim.g["jede#goto_assignments_split_command"] = "<leader>gS"
            vim.g["jede#goto_assignments_tab_command"] = "<leader>gT"
            vim.g["jede#goto_assignments_first_command"] = "<leader>gA"
            vim.g["jede#goto_assignments_first_split_command"] = "<leader>gF"
            vim.g["jede#goto_assignments_first_tab_command"] = "<leader>gH"
            vim.g["jede#rename_command"] = "<leader>r"
            vim.g["jede#usages_command"] = "<leader>u"
            vim.g["jede#usages_split_command"] = "<leader>U"
            vim.g["jede#usages_tab_command"] = "<leader>v"
            vim.g["jede#show_documentation_command"] = "<leader>K"
            vim.g["jede#show_documentation_split_command"] = "<leader>k"
            vim.g["jede#show_documentation_tab_command"] = "<leader>l"
            vim.g["jede#show_help_command"] = "<leader>?"
            vim.g["jede#show_help_split_command"] = "<leader>/"
            vim.g["jede#show_help_tab_command"] = "<leader>!"
        end
    },
    {
        "davidhalter/jedi",
        build = "python -m pip install --upgrade .",
        ft = { "python" },
    },
    {
        "ivanov/vim-ipython",
        ft = { "python" },
        -- init = function()
        --     vim.g.ipy_no_mappings = 1
        --     vim.g.ipy_no_performance_tweaks = 1
        --     vim.g.ipy_cell_delimiter = "# %%"
        --     vim.g.ipy_console = "ipython"
        --     vim.g.ipy_highlight_cells = 1
        --     vim.g.ipy_echo_in_console = 0
        --     vim.g.ipy_echo_in_vim = 1
        --     vim.g.ipy_silent_console = 1
        --     vim.g.ipy_completion = "jedi"
        --     vim.g.ipy_kernel_type = "local"
        --     vim.g.ipy_connect_on_startup = 0
        --     vim.g.ipy_mappings = {
        --         execute_cell = "<leader>rc",
        --         execute_cell_and_below = "<leader>rC",
        --         execute_cell_and_above = "<leader>ra",
        --         execute_line = "<leader>rl",
        --         execute_selection = "<leader>rs",
        --         interrupt_kernel = "<leader>ri",
        --         restart_kernel = "<leader>rR",
        --         connect_to_kernel = "<leader>rk",
        --         disconnect_from_kernel = "<leader>rK",
        --         show_doc = "<leader>rd",
        --         open_console = "<leader>ro",
        --     }
        -- end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c", "cpp", "lua", "python", "rust",
                    "javascript", "typescript",
                    "html", "css", "json",
                    "bash", "yaml",
                    "markdown", "markdown_inline",
                    "vim", "vimdoc",
                    "diff", "gitignore", "gitattributes", "gitcommit",
                    "java", "go", "cmake", "make", "dockerfile",
                    "regex", "jinja", "toml", "ini", "jinja_inline",
                },
                indent = {
                    enable = false,
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
                highlight = {
                    enable = false,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
    {
        "sheerun/vim-polyglot",
        init = function()
            vim.g.polyglot_disabled = { "autoindent", "c", "cpp", "markdown" }
        end
    },
}

