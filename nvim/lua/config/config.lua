-- This file will be loaded at the end of init.lua
-- This file is designed to add your own lua scripts or override the exVim's init.lua settings

-- set list
-- vim.opt.list = true
-- vim.opt.listchars = "tab:>-,trail:-"

-- yank data to clipboard
-- "#" means register.
-- "+" specifies the system clipboard register.
-- "y" is yank.

vim.keymap.set("n", "<leader>rt", function()
    ToggleTabExpand()
end)

vim.keymap.set("n", "<leader>yy", '"+yy')
vim.keymap.set("n", "<leader>dd", '"+dd')
vim.keymap.set("v", "<leader>gg", '"+yy')

vim.opt.expandtab = true
local toggletabexpand = 1

function ToggleTabExpand()
    if toggletabexpand == 1 then
        vim.opt.expandtab = false
        toggletabexpand = 0
    else
        vim.opt.expandtab = true
        toggletabexpand = 1
    end
end

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- 根据文件类型设置不同的缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"python", "javascript", "typescript", "html", "css", "json", "yaml"},
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "cpp", "java", "go"},
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Default colorscheme setup

if vim.env.TMUX ~= nil then
    if vim.opt.termguicolors ~= nil or vim.fn.has("gui_running") == 1 then
        vim.opt.termguicolors = true
        vim.g.t_8f = "\x1b[38;2;%lu;%lu;%lum"
        vim.g.t_8b = "\x1b[48;2;%lu;%lu;%lum"
    end
    if vim.fn.has("nvim") == 1 then
        vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
    end
end

local function vim_set_custom_background()
    if vim.fn.has("gui_running") == 1 then
        vim.opt.background = "dark"
    else
        vim.opt.background = "dark"
        -- vim.opt.t_Co = 256 -- make sure our terminal use 256 color
    end
end

local function vim_set_custom_cursorline()
    vim.opt.cursorline = true
    -- vim.api.nvim_set_hl(0, "CursorLine", { cterm = NONE, guibg = "#202727", guifg = NONE })
    -- vim.opt.cursorcolumn = true
    -- vim.api.nvim_set_hl(0, "CursorColumn", { cterm = NONE, ctermbg = "darkred", ctermfg = "white", guibg = "darkred", guifg = "white" })
end

vim.cmd("colorscheme gruvcase")

-- Toggle mouse function
function ToggleMouse()
    -- check if mouse is enabled
    if vim.opt.mouse == "a" then
        -- disable mouse
        vim.opt.mouse = ""
    else
        -- enable mouse everywhere
        vim.opt.mouse = "a"
    end
end

-- keyboard mappings
vim.keymap.set("n", "<C-g>", function() ToggleMouse() end)
-- map <C-v> <C-a>
-- C-x to decrease and C-a/C-s to increase num
vim.keymap.set("", "<C-s>", "<C-a>")
-- set clipboard=unnamed

vim.keymap.set("n", "<S-k>", ":tabp<CR>")
vim.keymap.set("n", "<S-l>", ":tabn<CR>")
vim.keymap.set("n", "<S-h>", ":bp<CR>")
vim.keymap.set("n", "<S-j>", ":bn<CR>")
vim.keymap.set("n", "t[", ":tabp<CR>")
vim.keymap.set("n", "t]", ":tabn<CR>")
vim.keymap.set("n", "b[", ":bp<CR>")
vim.keymap.set("n", "b]", ":bn<CR>")
