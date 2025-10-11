--
--------------------------------------------------------------------------------
--         File:  theme.lua
--
--        Usage:  ./theme.lua
--
--  Description:
--
--      Options:  ---
-- Requirements:  ---
--         Bugs:  ---
--        Notes:  ---
--       Author:  lijin (jin), <jinli@syncore.space>
-- Organization:  SYNCORE
--      Version:  1.0
--      Created:  2025年09月22日
--     Revision:  ---
--------------------------------------------------------------------------------
--



return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp", "lua", "python", "rust", "javascript", "typescript", "html", "css", "json", "bash", "yaml", "markdown", "markdown_inline" },
                indent = {
                    enable = false,
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
            })
        end,
    },
    {
        "princeofdream/gruvcase",
        config = function()
            vim.g.gruvbox_contrast_dark = "soft"
        end,
    },
    {
        "projekt0n/github-nvim-theme",
    },
    {
        "morhetz/gruvbox",
    },
    {
        "navarasu/onedark.nvim",
        config = function()
            require('lualine').setup {
                style = 'darker',
                transparent = false,
                term_colors = true,
                ending_tildes = false,
                cmp_itemkind_reverse = false,
                toggle_style_key = nil,
                toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'},
                code_style = {
                comments = 'italic',
                keywords = 'none',
                functions = 'none',
                strings = 'none',
                variables = 'none'
                },
                lualine = {
                    transparent = false,
                },
                colors = {},
                highlights = {},
                diagnostics = {
                    darker = true,
                    undercurl = true,
                    background = true,
                },
            }
        end,
    },
    {
        "morhetz/gruvbox",
    },
    {
        "sonph/onehalf",
    },
    {
        "ayu-theme/ayu-vim",
    },

    {
        "jiangmiao/auto-pairs",
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        lazy = false,
        -- opts = {
        --     blacklist = {'cmake'},
        -- },
        config = function()
            vim.g.rainbow_delimiters = {
                highlight = {
                    'RainbowDelimiterRed',
                    -- 'RainbowDelimiterViolet',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterCyan',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterPurple',
                },
            }
        end,
    },
    -- {
    --     "kien/rainbow_parentheses.vim",
    --     event = "BufRead",
    --     config = function()
    --         -- vim.g.rainbow#max_file_lines = 1000
    --         -- vim.g.rainbow#max_level = 16
    --         -- vim.g.rainbow#pairs = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
    --         vim.cmd("RainbowParenthesesActivate")
    --         -- vim.cmd("autocmd BufEnter * RainbowParenthesesLoadRound")
    --         vim.cmd("autocmd BufEnter * RainbowParenthesesLoadSquare")
    --         vim.cmd("autocmd BufEnter * RainbowParenthesesLoadBraces")
    --     end,
    -- },

    -- Focuspoint
    {
        "chase/focuspoint-vim",
        event = "VeryLazy",
    },
    -- Molokai 主题
    {
        "tomasr/molokai",
        lazy = false, -- 主题通常不希望延迟加载
        priority = 1000,
        config = function()
            vim.g.molokai_original = 1
            vim.g.rehash256 = 1
        end,
    },

    -- Palenight 主题
    {
        "drewtempelmeyer/palenight.vim",
        lazy = false,
        priority = 1000,
    },

    -- Ayu 主题
    {
        "ayu-theme/ayu-vim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.ayu_mirage = false
            vim.g.ayu_transparency = false
        end,
    },

    -- Nord 主题
    {
        "arcticicestudio/nord-vim",
        lazy = false,
        priority = 1000,
    },

    -- Oceanic Next 主题
    {
        "mhartington/oceanic-next",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.oceanic_next_terminal_bold = 1
            vim.g.oceanic_next_terminal_italic = 1
        end,
    },

    -- Flattened 主题
    {
        "romainl/flattened",
        lazy = false,
        priority = 1000,
    },

    -- Tomorrow 主题
    {
        "chriskempson/tomorrow-theme",
        lazy = false,
        priority = 1000,
    },

    -- Semantic Highlight
    {
        "jaxbot/semantic-highlight.vim",
        event = "VeryLazy",
        config = function()
            -- 定义颜色
            local semanticGUIColors = {
                '#72d572', '#c5e1a5', '#e6ee9c', '#fff59d', '#ffe082', '#ffcc80',
                '#ffab91', '#bcaaa4', '#b0bec5', '#ffa726', '#ff8a65', '#f9bdbb',
                '#f9bdbb', '#f8bbd0', '#e1bee7', '#d1c4e9', '#ffe0b2', '#c5cae9',
                '#d0d9ff', '#b3e5fc', '#b2ebf2', '#b2dfdb', '#a3e9a4', '#dcedc8',
                '#f0f4c3', '#ffb74d'
            }

            local semanticTermColors = {
                28, 1, 2, 3, 4, 5, 6, 7, 25, 9, 10, 34, 12, 13, 14, 15, 16, 125, 124, 19
            }

            -- 设置变量
            vim.g.semanticGUIColors = semanticGUIColors
            vim.g.semanticTermColors = semanticTermColors

            -- 创建键映射
            vim.keymap.set("n", "<Leader>s", "<cmd>SemanticHighlightToggle<cr>", { desc = "Toggle semantic highlight" })
        end,
    },

    -- Startify 启动界面
    {
        "mhinz/vim-startify",
        event = "VimEnter",
        config = function()
            -- 可以在这里添加 startify 的配置
            vim.g.startify_session_dir = "~/.config/nvim/sessions"
            vim.g.startify_lists = {
                { type = 'sessions', header = {'   Sessions'} },
                { type = 'files', header = {'   Files'} },
                { type = 'dir', header = {'   Current Directory ' .. vim.fn.getcwd()} },
                { type = 'bookmarks', header = {'   Bookmarks'} },
            }
        end,
    },

    -- AOSP Vim
    {
        "rubberduck203/aosp-vim",
        ft = {"java", "cpp", "c"}, -- 只在特定文件类型加载
    },

    -- Inlay Hints
    {
        "simrat39/inlay-hints.nvim",
        event = "LspAttach",
        config = function()
            require("inlay-hints").setup()
        end,
    },
    {
        "nvim-tree/nvim-web-devicons"
    },
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        config = function()
            local colors = {
                blue   = '#80a0ff',
                cyan   = '#79dac8',
                black  = '#080808',
                white  = '#c6c6c6',
                red    = '#ff5189',
                violet = '#d183e8',
                grey   = '#303030',
            }

            local bubbles_theme = {
                normal = {
                    a = { fg = colors.black, bg = colors.violet },
                    b = { fg = colors.white, bg = colors.grey },
                    c = { fg = colors.white },
                },

                insert = { a = { fg = colors.black, bg = colors.blue } },
                visual = { a = { fg = colors.black, bg = colors.cyan } },
                replace = { a = { fg = colors.black, bg = colors.red } },

                inactive = {
                    a = { fg = colors.white, bg = colors.black },
                    b = { fg = colors.white, bg = colors.black },
                    c = { fg = colors.white },
                },
            }
            local gruvcase = {
                normal = {
                    a = { fg = colors.black, bg = colors.violet },
                    b = { fg = colors.white, bg = colors.grey },
                    c = { fg = colors.white },
                },
            }

            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    -- theme = 'auto',
                    -- theme = 'gruvbox',
                    theme = 'dracula',
                    -- theme = 'onedark',
                    -- theme = bubbles_theme,
                    -- theme = gruvcase,
                    -- component_separators = '',
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '', right = ''},
                    -- section_separators = { left = '', right = ''},
                    -- disabled_filetypes = {
                    --     statusline = {},
                    --     winbar = {},
                    -- },
                    ignore_focus = {},
                    always_divide_middle = true,
                    always_show_tabline = true,
                    globalstatus = false,
                    refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                    refresh_time = 16, -- ~60fps
                    events = {
                        'WinEnter',
                        'BufEnter',
                        'BufWritePost',
                        'SessionLoadPost',
                        'FileChangedShellPost',
                        'VimResized',
                        'Filetype',
                        'CursorMoved',
                        'CursorMovedI',
                        'ModeChanged',
                    },
                    }
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
                -- sections = {
                --     lualine_a = {
                --         {
                --             'mode',
                --             icons_enabled = true, -- Enables the display of icons alongside the component.
                --             icon = nil,
                --             separator = nil,      -- Determines what separator to use for the component.
                --             cond = nil,           -- Condition function, the component is loaded when the function returns `true`.
                --             draw_empty = false,   -- Whether to draw component even if it's empty.
                --             color = nil, -- The default is your theme's color for that section and mode.
                --             type = nil,
                --             padding = 1, -- Adds padding to the left and right of components.
                --             fmt = nil,   -- Format function, formats the component's output.
                --             on_click = nil, -- takes a function that is called when component is clicked with mouse.
                --         },
                --     },
                -- },
                inactive_sections = {
                    lualine_a = {"mode"},
                    lualine_b = {"branch"},
                    lualine_c = {{'filename', path = 1}},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {
                    lualine_a = {
                        {
                            'tabs',
                            -- mode = 2,  -- 显示 tab 编号 + 名称
                            mode = 4,
                            -- tabs_color = {
                            --     active = { fg = '#2b2e34', bg = '#c77adb', gui = 'bold' },
                            --     inactive = { fg = '#acb3be', bg = '#404652' },
                            --     -- active = 'lualine_{section}_normal',     -- Color for active tab.
                            --     -- inactive = 'lualine_{section}_inactive', -- Color for inactive tab.
                            -- },
                            symbols = {
                                modified = ' ●',     -- 修改过的缓冲区标记
                                alternate_file = '#', -- 替代文件标记
                                directory = '',     -- 目录标记
                            },
                            max_length = vim.o.columns * 9 / 10, -- 最大长度，防止 tab 太多时溢出
                            fmt = function(name)
                                -- 截断过长的 tab 名称
                                if #name > 30 then
                                    return name:sub(1, 27) .. '...'
                                else
                                    return name
                                end
                            end,
                            -- padding = 2, -- 左右各加 2 个空格
                            -- separator = { left = '', right = ''
                        }

                    },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {
                        {
                            'filetype',
                            colored = true, -- Displays filetype icon in color if set to true
                            icon_only = false, -- Display only an icon for filetype
                            separator = nil,
                            padding = { left = 1, right = 0 },
                        }
                    },
                    lualine_z = {
                        -- {
                        --     'buffers',
                        --     mode = 4,  -- 显示缓冲区编号 + 名称
                        --     symbols = {
                        --         modified = ' ●',     -- 修改过的缓冲区标记
                        --         alternate_file = '#', -- 替代文件标记
                        --         directory = '',     -- 目录标记
                        --     },
                        --     buffers_color = {
                        --         active = { fg = '#2b2e34', bg = '#c77adb', gui = 'bold' },
                        --         inactive = { fg = '#acb3be', bg = '#404652' },
                        --     },
                        -- }
                    },
                },
                winbar = {
                    lualine_a = {
                        {
                            'filename', path = 1,
                            -- color = { fg = '#323232', bg = '#63b0ed'},
                            -- color = { bg = '#63b0ed'},
                        }
                    },
                    lualine_b = {
                        {
                            'filetype',
                            icon_only = false,
                            -- color = { bg = 'grey'},
                            -- color = { bg = '#63b0ed'},
                            -- separator = nil,
                            padding = { left = 1, right = 1 },
                        }
                    },
                    lualine_c = {
                    },
                    lualine_x = {},
                    lualine_y = {
                        {
                            'buffers',
                            mode = 4,  -- 显示缓冲区编号 + 名称
                            symbols = {
                                modified = ' ●',     -- 修改过的缓冲区标记
                                alternate_file = '#', -- 替代文件标记
                                directory = '',     -- 目录标记
                            },
                            -- buffers_color = {
                            --     active = { fg = '#2b2e34', bg = '#cccccc', gui = 'bold' },
                            --     inactive = { fg = '#acb3be', bg = '#404652' },
                            -- },
                            max_length = vim.o.columns * 2 / 5,
                        },
                    },
                    lualine_z = {
                        {
                            'mode',
                            icons_enabled = true,
                            -- color = { fg = '#ffffff', bg = '#cccc00', gui = 'bold' },
                        }
                    }
                },
                inactive_winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        {
                            'filename', path = 1,
                        }
                    },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {
                    }
                },
                extensions = {}
            }
        end,
    },
}


