" This file will be loaded at the end of .vimrc.
" This file is designed to add your own vim scripts or override the exVim's .vimrc settings.

" set list
" set listchars=tab:>-,trail:-


nnoremap <leader>rt :call ToggleTabExpand()<CR>

let s:toggletabexpand = 0
function! ToggleTabExpand()
    if s:toggletabexpand
        set noexpandtab
        let s:toggletabexpand = 0
    else
        set expandtab
        let s:toggletabexpand = 1
    endif
endfunction

"/////////////////////////////////////////////////////////////////////////////
" Default colorscheme setup
"/////////////////////////////////////////////////////////////////////////////

if !empty($TMUX)
	if exists('+termguicolors') || has('gui_running')
		set termguicolors
		let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
		let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	endif
	if (has("nvim"))
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
endif

function! s:vim_set_custom_background()
	if has('gui_running')
		set background=dark
	else
		set background=dark
		" set t_Co=256 " make sure our terminal use 256 color
	endif
endfunction

function! s:vim_set_custom_cursorline()
	set cursorline
	" hi CursorLine   cterm=NONE guibg=#202727 guifg=NONE
	" set cursorcolumn
	" hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
endfunction

function! s:vim_set_custom_colorscheme(vim_theme)
	if a:vim_theme == "one"
		colorscheme one
		" call one#highlight('vimLineComment', 'cc00cc', '', 'none')
		" hi CursorLine guibg=#202727 guifg=NONE
		" hi CursorLine guibg=#FFFFAF guifg=NONE
		" hi CursorLine guibg=#5c624b guifg=NONE
		" hi CursorLine guibg=#434837 guifg=NONE
		" let s:one_visual_bg='87FFFF'
		" let s:one_visual_bg='5FD7FF'
		let s:one_visual_bg='878777'
		call one#highlight('TabLineFill'  , ''       , s:one_visual_bg , 'none')
		call one#highlight('Visual'       , ''       , s:one_visual_bg , 'none')
		call one#highlight('VisualNOS'    , ''       , s:one_visual_bg , 'none')
		call one#highlight('CursorLine'   , ''       , '434837'        , 'none')
		call one#highlight('CursorLineNr' , 'AFFFD7' , '5F5F5F'        , 'none')
		" call one#highlight('PMenu'      , ''       , '333841'        , 'none')
		call one#highlight('PMenuSel'     , '4E4E4E' , '87AFAF'        , 'none')
	elseif a:vim_theme == "solarized"
		let g:solarized_termcolors = 256
		colorscheme solarized
	elseif a:vim_theme == "ayu_light"
		let g:ayucolor="light"  " for light version of theme
		colorscheme ayu
	elseif a:vim_theme == "ayu_mirage"
		let g:ayucolor="mirage" " for mirage version of theme
		colorscheme ayu
	elseif a:vim_theme == "ayu_dark"
		let g:ayucolor="dark"   " for dark version of theme
		colorscheme ayu
	elseif a:vim_theme == "OceanicNext"
		colorscheme OceanicNext
	elseif a:vim_theme == "OceanicNextLight"
		colorscheme OceanicNextLight
	elseif a:vim_theme == "OceanicNextLight"
		colorscheme OceanicNextLight
	elseif a:vim_theme == "gruvbox"
		colorscheme gruvbox
	elseif a:vim_theme == "flattened_dark"
		colorscheme flattened_dark
	elseif a:vim_theme == "flattened_light"
		colorscheme flattened_light
	endif
endfunction

call s:vim_set_custom_background()
call s:vim_set_custom_cursorline()

if empty($TMUX)
	if ! has('gui_running')
		call s:vim_set_custom_colorscheme("gruvbox")
	else
		call s:vim_set_custom_colorscheme("one")
	endif
else
	call s:vim_set_custom_colorscheme("one")
endif

set pastetoggle=<F4>


