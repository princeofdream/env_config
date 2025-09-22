return
{
    {
        "scrooloose/nerdcommenter",
        event = "VeryLazy",  -- 在需要时加载，而不是在启动时
        config = function()
            -- 设置 NERDCommenter 的选项
            vim.g.NERDSpaceDelims = 1  -- 在注释后添加空格
            vim.g.NERDRemoveExtraSpaces = 1  -- 删除注释后多余的空格
            vim.g.NERDCompactSexyComs = 1  -- 使用紧凑的多行注释样式

            -- 将行注释对齐到左侧，而不是跟随代码缩进
            vim.g.NERDDefaultAlign = 'left'

            -- 切换注释时检查所有行
            vim.g.NERDToggleCheckAllLines = 1

            -- 自定义注释符
            vim.g.NERDCustomDelimiters = {
                rc = { left = '#' }
            }

            -- 设置键映射
            vim.keymap.set("n", "<F10>", "<plug>NERDCommenterToggle", { desc = "Toggle comment" })
            vim.keymap.set("n", "<F11>", "<plug>NERDCommenterToggle", { desc = "Toggle comment" })

            -- 你也可以为其他模式添加映射
            vim.keymap.set("v", "<F10>", "<plug>NERDCommenterToggle<gv>", { desc = "Toggle comment" })
            vim.keymap.set("v", "<F11>", "<plug>NERDCommenterToggle<gv>", { desc = "Toggle comment" })
        end,
    },
}
