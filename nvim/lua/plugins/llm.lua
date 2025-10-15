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
            vim.g.vim_ai_chat = {
                provider = "openai",
                prompt = "you are a professional code assistant, help me write code and explain code",
                options = {
                    model = "gpt-4o",
                    endpoint_url = "http://chat.gxatek.com/api/azure/deployments/gpt-4o/chat/completions",
                    max_tokens = 0,
                    max_completion_tokens = 0,
                    temperature = 0.1,
                    request_timeout = 20,
                    stream = 1,
                    auth_type = "none",
                    token_file_path = "",
                    token_load_fn = "",
                    selection_boundary = "#####",
                    frequency_penalty = "",
                    logit_bias = "",
                    logprobs = "",
                    presence_penalty = "",
                    reasoning_effort = "",
                    seed = "",
                    stop = "",
                    top_logprobs = "",
                    top_p = "",
                },
                ui = {
                    paste_mode = 1,
                },
            }
            vim.g.vim_ai_complete = {
                provider = "openai",
                prompt = "you are a professional code assistant, help me write code and modify code. \
                    Do not have any extra explanation, Do Not delete any code, \
                    just add code based on my requirement, \
                    Do not use any markdown format in code edit, ",
                options = {
                    model= "gpt-4o",
                    endpoint_url = "http://chat.gxatek.com/api/azure/deployments/gpt-4o/chat/completions",
                    max_tokens= 0,
                    max_completion_tokens= 0,
                    temperature= 0.1,
                    request_timeout= 20,
                    stream= 1,
                    auth_type = "none",
                    token_file_path= "",
                    token_load_fn= "",
                    selection_boundary= "#####",
                    frequency_penalty= "",
                    logit_bias= "",
                    logprobs= "",
                    presence_penalty= "",
                    reasoning_effort= "",
                    seed= "",
                    stop= "",
                    top_logprobs= "",
                    top_p= "",
                    reasoning= "",
                },
                ui= {
                    paste_mode= 1,
                },
            }
            vim.g.vim_ai_edit = vim.g.vim_ai_complete
        end,
    },
    {
        "github/copilot.vim",
        config = function()
        end,
    }
}
