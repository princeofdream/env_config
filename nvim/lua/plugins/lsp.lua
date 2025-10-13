--
--------------------------------------------------------------------------------
--         File:  lsp.lua
--
--        Usage:  ./lsp.lua
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
    -- add symbols-outline
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
        opts = {
            -- add your options that should be passed to the setup() function here
            position = "right",
        },
    },
    -- nvim-cmp 是 Neovim 的代码补全插件
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",      -- LSP 源
            "hrsh7th/cmp-buffer",        -- 缓冲区源
            "hrsh7th/cmp-path",          -- 路径源
            "saadparwaiz1/cmp_luasnip",  -- Snippets 源
            "L3MON4D3/LuaSnip",          -- Snippets 引擎
            "rafamadriz/friendly-snippets", -- 预定义 snippets
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- 加载 friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            -- 检查光标前是否有空格的 Lua 实现
            local function check_backspace()
                local col = vim.fn.col(".") - 1
                return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    -- 原来的 <C-n> 映射，现在使用 nvim-cmp 的功能
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif check_backspace() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- 原来的 <C-l> 映射，现在使用 nvim-cmp 的功能
                    ["<C-l>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- 其他常用的映射
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),

                    -- -- Tab 键用于 snippets 导航
                    -- ["<Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --     elseif luasnip.expand_or_jumpable() then
                    --         luasnip.expand_or_jump()
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),

                    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_prev_item()
                    --     elseif luasnip.jumpable(-1) then
                    --         luasnip.jump(-1)
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),

                    ["<Down>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jump() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<Up>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "luasnip" },
                },
                formatting = {
                    format = function(entry, vim_item)
                        -- 为每个条目添加源名称
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                            luasnip = "[Snippet]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                experimental = {
                    ghost_text = true,
                },
            })

            -- 自动补全括号
            local autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", autopairs.on_confirm_done())
        end,
    },
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        },
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            {
                "mason-org/mason.nvim", opts = {}
            },
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls", "html", "cssls", "jsonls" },
                automatic_installation = true,
            })

            -- 使用新的 vim.lsp.config API
            local servers = { "lua_ls", "rust_analyzer", "ts_ls", "html", "cssls", "jsonls" }
            for item, server in ipairs(servers) do
                vim.lsp.config(server, {
                    -- 这里可以添加特定服务器的配置
                })
                vim.lsp.enable(server)
            end
            -- 特定服务器配置
            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                            },
                            checkThirdParty = false,
                            -- 增加文件大小限制（以字节为单位）
                            maxFileSize = 5 * 1024 * 1024,  -- 5 MB
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
            vim.lsp.enable("lua_ls")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp"},

        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls", "html", "cssls", "jsonls" },
                automatic_installation = true,
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- 为所有 LSP 服务器设置默认配置
            -- require("mason-lspconfig").setup_handlers({
            --   function(server_name)
            --     lspconfig[server_name].setup({
            --       capabilities = capabilities,
            --     })
            --   end,
            -- })

            -- 为特定服务器设置自定义配置
            -- lspconfig.lua_ls.setup({
            --     capabilities = capabilities,
            --     settings = {
            --         Lua = {
            --             diagnostics = {
            --                 globals = { "vim" },
            --             },
            --         },
            --     },
            -- })
        end,

    },

    -- 自动配对括号、引号等
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
}
