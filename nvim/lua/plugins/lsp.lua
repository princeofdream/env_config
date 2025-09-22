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
  }
}
