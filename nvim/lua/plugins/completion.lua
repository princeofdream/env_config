return {
    "neoclide/coc.nvim",
    build = "yarn install --frozen-lockfile",
    dependencies = {
        "antoinemadec/FixCursorHold.nvim",
        "folke/neodev.nvim",
    },
    config = function()
        require("config.coc").setup()
    end,
    keys = {
        { "<leader>ca", "<Plug>(coc-codeaction)", desc = "Code action" },
    }
}
