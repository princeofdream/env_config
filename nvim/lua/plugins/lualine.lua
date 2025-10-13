return {
{
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        config = function()
            local colors = {
                -- blue   = '#80a0ff',
                blue        = '#63b0ed',
                cyan        = '#79dac8',
                black       = '#080808',
                white       = '#c6c6c6',
                red         = '#ff5189',
                lightred    = '#e06c75',
                violet      = '#d183e8',
                orange      = '#ffb86c',
                purple      = '#bd93f9',
                yellow      = '#f1fa8c',
                green       = '#50fa7b',
                lightgreen  = '#baed63',
                lightyellow = '#ffffa5',
                lightgray   = '#7a86ac',
                gray        = '#2b2e36',
                drarkgray   = '#353a40',
                -- red        = '#ff5555',
                -- white      = '#f8f8f2',
                -- black      = '#282a36',
            }

            local gruvcase = {
                normal = {
                    a = { bg = colors.purple, fg = colors.black, gui = 'bold' },
                    b = { bg = colors.lightgray, fg = colors.black },
                    c = { bg = colors.drarkgray, fg = colors.white },
                },
                insert = {
                    a = { bg = colors.lightgreen, fg = colors.black, gui = 'bold' },
                    b = { bg = colors.lightgray, fg = colors.white },
                    c = { bg = colors.drarkgray, fg = colors.white },
                },
                visual = {
                    a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
                    b = { bg = colors.lightgray, fg = colors.white },
                    c = { bg = colors.drarkgray, fg = colors.white },
                },
                replace = {
                    a = { bg = colors.lightred, fg = colors.black, gui = 'bold' },
                    b = { bg = colors.lightgray, fg = colors.white },
                    c = { bg = colors.drarkgray, fg = colors.white },
                },
                command = {
                    a = { bg = colors.orange, fg = colors.black, gui = 'bold' },
                    b = { bg = colors.lightgray, fg = colors.white },
                    c = { bg = colors.drarkgray, fg = colors.white },
                },
                inactive = {
                    a = { bg = colors.gray, fg = colors.white, gui = 'bold' },
                    b = { bg = colors.gray, fg = colors.white },
                    c = { bg = colors.drarkgray, fg = colors.white },
                },
            }

            require('lualine').setup {
                options = {
                    -- theme = 'codedark',
                    -- theme = 'dracula',
                    -- theme = 'everforest',
                    -- theme = 'gruvbox_dark',
                    -- theme = 'gruvbox_light',
                    -- theme = 'gruvbox',
                    -- theme = 'gruvbox-material',
                    -- -- theme = 'horizon',
                    -- theme = 'iceberg_dark',
                    -- theme = 'iceberg_light',
                    -- theme = 'iceberg',
                    -- theme = 'jellybeans',
                    -- theme = 'material',
                    -- theme = 'modus-vivendi',
                    -- theme = 'moonfly',
                    -- theme = 'OceanicNext',
                    -- theme = 'palenight',
                    -- theme = 'solarized_dark',
                    -- theme = 'solarized_light',
                    -- theme = 'solarized',
                    -- theme = 'Tomorrow',
                    -- theme = 'tomorrow_night',
                    -- theme = 'wombat',

                    -- theme = 'dracula',
                    -- theme = 'onedark',
                    theme = gruvcase,
                    -- component_separators = '',
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '', right = ''},
                     icons_enabled = true,

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
                            max_length = function()
                                return vim.o.columns * 9 / 10
                            end,
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
                            colored = true,
                            icon_only = false,
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
                            colored = true,
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
                            -- max_length = vim.o.columns * 1 / 4,
                            max_length = function()
                                return vim.api.nvim_win_get_width(0) * 3 / 5
                            end,
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
