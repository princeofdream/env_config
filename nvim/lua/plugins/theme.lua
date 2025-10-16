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
        "princeofdream/gruvcase",
        config = function()
            vim.g.gruvbox_contrast_dark = "soft"
            -- vim.cmd([[colorscheme gruvcase]])
            vim.cmd([[colorscheme gruvcase_one]])
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
}

