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
        "Civitasv/cmake-tools.nvim",
        opts = {
            cmake_executable = "cmake", -- Path to cmake executable
            cmake_build_directory = "build", -- Path to build directory
            cmake_generate_options = {}, -- Extra options for cmake generation step
            cmake_build_options = {}, -- Extra options for cmake build step
            cmake_console_size = 10, -- Height of the CMake output window
            cmake_show_console = "always", -- When to show the CMake output window
            cmake_dap_configuration = { name = "Launch file", type = "codelldb", request = "launch" }, -- DAP configuration for debugging
            cmake_dap_open_command = function()
                require("dap").repl.open()
            end, -- Command to open the DAP repl window
        },
        config = function()
        end
    },
    {
        "davidhalter/jedi-vim",
        init = function()
            vim.g.jedi_completions_enabled = 1
            vim.g.jedi_use_tabs_not_buffers = 1
            vim.g.jedi_show_call_signatures = "1"
            vim.g.jedi_popup_on_dot = 1
            vim.g.jedi_popup_select_first = 0
            vim.g.jedi_auto_initialization = 1
            vim.g.jedi_goto_command = "<leader>j"
            vim.g.jedi_goto_assignments_command = "<leader>J"
            vim.g.jedi_goto_definition_command = "<leader>gd"
            vim.g.jedi_goto_definition_split_command = "<leader>gD"
            vim.g.jedi_goto_definition_tab_command = "<leader>gt"
            vim.g.jedi_goto_assignments_split_command = "<leader>gS"
            vim.g.jedi_goto_assignments_tab_command = "<leader>gT"
            vim.g.jedi_goto_assignments_first_command = "<leader>gA"
            vim.g.jedi_goto_assignments_first_split_command = "<leader>gF"
            vim.g.jedi_goto_assignments_first_tab_command = "<leader>gH"
            vim.g.jedi_rename_command = "<leader>r"
            vim.g.jedi_usages_command = "<leader>u"
            vim.g.jedi_usages_split_command = "<leader>U"
            vim.g.jedi_usages_tab_command = "<leader>v"
            vim.g.jedi_show_documentation_command = "<leader>K"
            vim.g.jedi_show_documentation_split_command = "<leader>k"
            vim.g.jedi_show_documentation_tab_command = "<leader>l"
            vim.g.jedi_show_help_command = "<leader>?"
            vim.g.jedi_show_help_split_command = "<leader>/"
            vim.g.jedi_show_help_tab_command = "<leader>!"
        end
    },
    {
        "lepture/vim-jinja",
        ft = { "jinja", "jinja.html", "html.jinja", "htmldjango" },
        init = function()
            vim.g.jinja_syntax_conceal = 0
        end
    }
}

