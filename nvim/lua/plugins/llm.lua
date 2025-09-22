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
}
