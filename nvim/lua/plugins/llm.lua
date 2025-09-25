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
            require("vim-ai").setup({
                api_key = "None",
                model = "gpt-4o",
                temperature = 0.9,
                top_p = 1,
                top_k = 100,
                frequency_penalty = 0,
                presence_penalty = 0,
                max_tokens = 1024,
                stream = false,
                stop = { "\n" },
                log_level = "info",
                log_file = "~/.cache/vim-ai/logs/vim-ai.log",
                log_file_level = "info",
                log_file_format = "{timestamp} {level} {message}",
                log_file_date_format = "%Y-%m-%d %H:%M:%S",
                log_file_rotation = "daily",
                log_file_rotation_max_size = "100M",
                log_file_rotation_max_files = 5,
                log_file_rotation_max_size = "100M",
                log_file_rotation_max_files = 5,
                log_file_rotation_date_format = "%Y-%m-%d",
            })
        end,
    },
    {
        "github/copilot.vim",
        config = function()
            require("copilot").setup({
            })
        end,
    }
}
