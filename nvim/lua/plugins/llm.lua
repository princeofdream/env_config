return {
    {
        "Kurama622/llm.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"},
        cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
        config = function()
            require("llm").setup({
            url = "http://chat.gxatek.com/api/azure/deployments/gpt-4o/chat/completions",
            model = "gpt-4o",
            api_type = "openai"
            })
        end,
        keys = {
            { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
        },
    },
    {
        "madox2/vim-ai",
        config = function()
            -- vim.g.vim_ai_debug = 1
            -- vim.g.vim_ai_debug_log_file = vim.env.HOME .. "/.config/nvim/logs/ai/vim-ai.log"
        end,
    },
    {
        "github/copilot.vim",
        config = function()
        end,
    }
}
