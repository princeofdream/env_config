-- Neovim settings converted from vimrc

-- Platform detection functions
local function is_osx()
  return vim.fn.has('macunix') == 1
end

local function is_linux()
  return vim.fn.has('unix') == 1 and vim.fn.has('macunix') == 0 and vim.fn.has('win32unix') == 0
end

local function is_windows()
  return (vim.fn.has('win16') == 1 or vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1)
end

local function is_winunix()
  return (vim.fn.has('win32unix') == 1)
end

-- Set up runtimepath for Windows
if not vim.g.vim_pm_custom_path then
  if is_windows() then
    if vim.fn.has('nvim') == 1 then
      vim.g.vimfiler_dir = vim.fn.expand('~/AppData/Local/nvim')
      vim.opt.runtimepath:append(vim.fn.expand('$HOME/.vim,$HOME/vimfiles,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after,$HOME/vimfiles/after'))
      -- vim.opt.runtimepath:append(vim.fn.expand('~\AppData\Local\nvim,~\AppData\Local\nvim\after'))
    else
      vim.opt.runtimepath:append(vim.fn.expand('$HOME/.vim,$HOME/vimfiles,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after,$HOME/vimfiles/after'))
    end
  end
else
  vim.g.vim_pm_vimrc_path = vim.g.vim_pm_custom_path
end

-- Language and encoding setup
vim.opt.langmenu = "none"

-- Set language based on platform
if is_windows() then
  vim.cmd('silent language english')
elseif is_osx() then
  vim.cmd('silent language en_US')
else
  local uname = vim.fn.system("uname -s")
  if uname == "Darwin\n" then
    vim.cmd('silent language en_US')
  end
end

-- Set encoding to utf-8
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15"
-- vim.opt.termencoding = "utf-8"
-- vim.opt.scriptencoding = "utf-8"

vim.opt.filetype.plugin = "on"
vim.opt.filetype.indent = "on"
vim.opt.syntax = "on"

-- General settings
vim.opt.backup = true

-- Setup backup and swap directories
local data_dir = vim.fn.expand("$HOME") .. '/.data/'
local backup_dir = data_dir .. 'backup'
local swap_dir = data_dir .. 'swap'

if vim.fn.finddir(data_dir) == '' then
  vim.fn.mkdir(data_dir)
end
if vim.fn.finddir(backup_dir) == '' then
  vim.fn.mkdir(backup_dir)
end
if vim.fn.finddir(swap_dir) == '' then
  vim.fn.mkdir(swap_dir)
end

vim.opt.backupdir = vim.fn.expand("$HOME/.data/backup")
vim.opt.directory = vim.fn.expand("$HOME/.data/swap")

-- vim.opt.shellredir = ">%s\ 2>&1"
vim.opt.history = 100
vim.opt.updatetime = 1000
vim.opt.autoread = true
vim.opt.maxmempattern = 1000

-- Mouse settings
vim.opt.mouse = "a"
if vim.fn.has('mouse_sgr') == 1 then
  vim.opt.ttymouse = "sgr"
end

-- Visual settings
vim.opt.matchtime = 0
vim.opt.number = true
vim.opt.scrolloff = 0
vim.opt.wrap = false

-- if vim.fn.exists('+acd') == 1 and vim.fn.vversion() >= 703 then
--   vim.opt.noacd = true
-- end

-- GUI font settings
if vim.fn.has('gui_running') == 1 then
  vim.api.nvim_create_augroup('ex_gui_font', {})
  vim.api.nvim_create_autocmd('GUIEnter', {
    group = 'ex_gui_font',
    callback = function()
      vim.fn['s:set_gui_font']()
    end
  })

  -- Set GUI font function
  vim.api.nvim_create_user_command('SetGuiFont', function()
    vim.fn['s:set_gui_font']()
  end, {})

  -- Define the s:set_gui_font function
--   vim.fn['s:set_gui_font'] = function()
--     if vim.fn.has('gui_gtk2') == 1 then
--       if vim.fn.getfontname('DejaVu Sans Mono for Powerline') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
--       elseif vim.fn.getfontname('DejaVu Sans Mono for Powerline Book') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ Book\ 12'
--       elseif vim.fn.getfontname('DejaVu Sans Mono') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ 11'
--       else
--         vim.opt.guifont = 'Luxi\ Mono\ 11'
--       end
--     elseif vim.fn.has('x11') == 1 then
--       if vim.fn.getfontname('DejaVu Sans Mono for Powerline') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
--       elseif vim.fn.getfontname('DejaVu Sans Mono for Powerline Book') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ Book\ 12'
--       elseif vim.fn.getfontname('DejaVu Sans Mono') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ 11'
--       else
--         vim.opt.guifont = 'Luxi\ Mono\ 11'
--       end
--     elseif is_osx() then
--       if vim.fn.getfontname('DejaVu Sans Mono for Powerline') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline:h15'
--       elseif vim.fn.getfontname('DejaVu Sans Mono for Powerline Book') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ Book\ 12'
--       elseif vim.fn.getfontname('DejaVu Sans Mono') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono:h15'
--       end
--     elseif is_windows() then
--       if vim.fn.getfontname('DejaVu Sans Mono for Powerline') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline:h11:cANSI'
--       elseif vim.fn.getfontname('DejaVu Sans Mono for Powerline Book') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ Book\ 12'
--       elseif vim.fn.getfontname('DejaVu Sans Mono') ~= '' then
--         vim.opt.guifont = 'DejaVu\ Sans\ Mono:h11:cANSI'
--       elseif vim.fn.getfontname('Consolas') ~= '' then
--         vim.opt.guifont = 'Consolas:h11:cANSI'
--       else
--         vim.opt.guifont = 'Lucida_Console:h11:cANSI'
--       end
--     end
--   end
-- end

-- Vim UI settings
vim.opt.wildmenu = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.shortmess = "aoOtTI"
vim.opt.lazyredraw = true
vim.opt.display = "lastline"
vim.opt.laststatus = 2
-- vim.opt.titlestring = "%t\ (%{expand("%:p:.:h")}/)"

-- Window size settings for GUI
if vim.fn.has('gui_running') == 1 then
  if vim.fn.exists('+lines') == 1 then
    vim.opt.lines = 40
  end
  if vim.fn.exists('+columns') == 1 then
    vim.opt.columns = 130
  end
end

vim.opt.showfulltag = true
vim.opt.guioptions = vim.opt.guioptions:get() .. "-b"

if vim.fn.has('nvim') == 0 then
  vim.opt.guioptions = vim.opt.guioptions:get() .. "+m"
  vim.opt.guioptions = vim.opt.guioptions:get() .. "-T"
end

-- Text editing settings
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backspace = "indent,eol,start"
vim.opt.cinoptions = ">s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30"
vim.opt.cindent.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.visualbell = "block"
vim.opt.numberformat = ""

-- Fold settings
vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "{,}"
vim.opt.foldlevel = 9999

-- Search settings
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Grep settings
-- vim.opt.grepprg = "lid\ -Rgrep\ -s"
vim.opt.grepformat = "%f:%l:%m"

-- Auto commands
-- if vim.fn.has('autocmd') == 1 then
--   vim.api.nvim_create_augroup('ex', {})
--   vim.api.nvim_create_autocmd('BufReadPost', {
--     group = 'ex',
--     pattern = '*',
--     callback = function()
--       if vim.fn.line("'"") > 0 and vim.fn.line("'"") <= vim.fn.line("$") then
--         vim.cmd('normal g`"')
--       end
--     end
--   })

  vim.api.nvim_create_autocmd({'BufNewFile', 'BufEnter'}, {
    group = 'ex',
    pattern = '*',
    callback = function()
      vim.opt.cpoptions = vim.opt.cpoptions:get() .. "d"
    end
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = 'ex',
    pattern = '*',
    callback = function()
      vim.cmd('syntax sync fromstart')
    end
  })

  vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    group = 'ex',
    pattern = '*.avs',
    callback = function()
      vim.opt.syntax = 'avs'
    end
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = 'ex',
    pattern = 'text',
    callback = function()
      vim.opt_local.textwidth = 78
    end
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = 'ex',
    pattern = 'c,cpp,cs,swig',
    callback = function()
      vim.opt_local.modeline = false
    end
  })

  -- Set comments for different file types
  -- vim.api.nvim_create_autocmd('FileType', {
  --   group = 'ex',
  --   pattern = 'c,cpp,java,javascript',
  --   callback = function()
  --     vim.opt_local.comments = 'sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://'
  --   end
  -- })

  -- vim.api.nvim_create_autocmd('FileType', {
  --   group = 'ex',
  --   pattern = 'cs',
  --   callback = function()
  --     vim.opt_local.comments = 'sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://'
  --   end
  -- })

  -- vim.api.nvim_create_autocmd('FileType', {
  --   group = 'ex',
  --   pattern = 'vim',
  --   callback = function()
  --     vim.opt_local.comments = 'sO:"\ -,mO:"\ \ ,eO:"",f:"'
  --   end
  -- })

  vim.api.nvim_create_autocmd('FileType', {
    group = 'ex',
    pattern = 'lua',
    callback = function()
      vim.opt_local.comments = 'f:--'
    end
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = 'ex',
    pattern = 'python,coffee',
    callback = function()
      vim.fn['s:check_if_expand_tab']()
    end
  })
end

-- Define check_if_expand_tab function
vim.fn['s:check_if_expand_tab'] = function()
  local has_noexpandtab = vim.fn.search('^\t', 'wn')
  local has_expandtab = vim.fn.search('^    ', 'wn')

  if has_noexpandtab == 1 and has_expandtab == 1 then
    local idx = vim.fn.inputlist({
      'ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
      '1. expand (tab=space, recommended)',
      '2. noexpand (tab=\t, currently have risk)',
      '3. do nothing (I will handle it by myself)'
    })

    local tab_space = string.rep(' ', vim.opt.tabstop:get())

    if idx == 1 then
      has_noexpandtab = 0
      has_expandtab = 1
      vim.cmd(string.format('silent %%s/\t/%s/g', tab_space))
    elseif idx == 2 then
      has_noexpandtab = 1
      has_expandtab = 0
      vim.cmd(string.format('silent %%s/%s/\t/g', tab_space))
    else
      return
    end
  end

  if has_noexpandtab == 1 and has_expandtab == 0 then
    print('substitute space to TAB...')
    vim.opt.expandtab = false
    print('done!')
  elseif has_noexpandtab == 0 and has_expandtab == 1 then
    print('substitute TAB to space...')
    vim.opt.expandtab = true
    print('done!')
  else
    -- It may be a new file, use original vim setting
  end
end

-- Key mappings
vim.api.nvim_set_keymap('n', 'Q', 'gq', { noremap = true })

-- Copy/paste mappings based on clipboard
if vim.opt.clipboard:get() == 'unnamed' then
  -- Fix visual paste bug in vim
  -- vnoremap <silent>p :call g:()<CR>
else
  -- General copy/paste
  vim.api.nvim_set_keymap('n', '<leader>y', '"*y', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>p', '"*p', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>P', '"*P', { noremap = true })
end

-- Copy folder path to clipboard
vim.api.nvim_set_keymap('n', '<leader>y1', 
  ':let @*=fnamemodify(bufname("%"),":p:h")<CR>', 
  { noremap = true, silent = true }
)

-- Copy file name to clipboard
vim.api.nvim_set_keymap('n', '<leader>y2', 
  ':let @*=fnamemodify(bufname("%"),":p:t")<CR>', 
  { noremap = true, silent = true }
)

-- Copy full path to clipboard
vim.api.nvim_set_keymap('n', '<leader>y3', 
  ':let @*=fnamemodify(bufname("%"),":p")<CR>', 
  { noremap = true, silent = true }
)

-- Toggle search pattern highlight
vim.api.nvim_set_keymap('n', '<leader>/', ':let @/=""<CR>', { noremap = true })

-- -- Terminal-specific key mappings
-- if vim.opt.term:get():match('^screen') then
--   vim.cmd [[execute "set <xUp>=\e[1;*A"]]
--   vim.cmd [[execute "set <xDown>=\e[1;*B"]]
--   vim.cmd [[execute "set <xRight>=\e[1;*C"]]
--   vim.cmd [[execute "set <xLeft>=\e[1;*D"]]
-- end

-- Window navigation with Shift+Arrow keys
vim.api.nvim_set_keymap('n', '<S-Up>', '<C-W><Up>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-Down>', '<C-W><Down>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-Left>', '<C-W><Left>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-Right>', '<C-W><Right>', { noremap = true })

-- Enhanced visual block shifting
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- Map Up/Down to gj/gk for wrapped text
vim.api.nvim_set_keymap('n', '<Up>', 'gk', { noremap = true })
vim.api.nvim_set_keymap('n', '<Down>', 'gj', { noremap = true })

-- -- Load local configuration
-- local vimrc_config_path = vim.g.vim_pm_vimrc_path .. 'config/' .. 'config.vim'
-- if vim.fn.filereadable(vim.fn.expand(vimrc_config_path)) == 1 then
--   vim.cmd('source ' .. vim.fn.fnameescape(vimrc_config_path))
-- end

-- Additional settings
vim.opt.tabpagemax = 50
