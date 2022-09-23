" This file will be loaded at the end of .vimrc.
" This file is designed to add your own vim scripts or override the exVim's .vimrc settings.

" set list
" set listchars=tab:>-,trail:-


nnoremap <leader>rt :call ToggleTabExpand()<CR>

" yank data to clipboard
"# " means register.
"# + specifies the system clipboard register.
"# y is yank.
nnoremap <leader>yy "+yy
nnoremap <leader>dd "+dd
vnoremap <leader>gg "+yy

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
		let s:one_visual_bg = '878777'
		let s:one_syntax_fg     = ['bcbcbc', '23']
		let s:one_syntax_cursor = ['323232', '235']
		let s:one_syntax_cursor_bg = ['3f3f3f', '235']
		call one#highlight('TabLineFill'  , ''       , s:one_visual_bg , 'none')
		call one#highlight('Visual'       , ''       , s:one_visual_bg , 'none')
		call one#highlight('VisualNOS'    , ''       , s:one_visual_bg , 'none')
		call one#highlight('CursorLine'   , ''       , '434837'        , 'none')
		call one#highlight('CursorLineNr' , 'AFFFD7' , '5F5F5F'        , 'none')
		" call one#highlight('PMenu'      , ''       , '333841'        , 'none')
		call one#highlight('PMenuSel'     , '4E4E4E' , '87AFAF'        , 'none')
		if empty($TMUX)
			if ! has('gui_running')
				" seperate line
				call one#highlight('VertSplit' , s:one_syntax_fg[0] , s:one_syntax_cursor[0] , 'none')
				" normal bg
				call one#highlight('Normal' , s:one_syntax_fg[0] , s:one_syntax_cursor[0] , '')
				" cursorline
				call one#highlight('CursorLine' , '' , s:one_syntax_cursor_bg[0] , 'none')
				call one#highlight('CursorLineNr' , 'ececec' , '5F5F5F'        , 'none')
			endif
		endif
	elseif a:vim_theme == "solarized"
		let g:solarized_termcolors = 256
		colorscheme solarized
	elseif a:vim_theme == "ayu_light"
		let g:ayucolor="light"  " for light version of theme
		colorscheme ayu
	elseif a:vim_theme == "onedark"
		colorscheme onedark
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
	elseif a:vim_theme == "gruvcase"
		colorscheme gruvcase
	elseif a:vim_theme == "onehalflight"
		set background=light
		colorscheme onehalflight
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
		call s:vim_set_custom_colorscheme("gruvcase")
		" call s:vim_set_custom_colorscheme("onehalflight")
		" call s:vim_set_custom_colorscheme("gruvbox")
		" call s:vim_set_custom_colorscheme("one")
	else
		call s:vim_set_custom_colorscheme("gruvcase")
		" call s:vim_set_custom_colorscheme("onehalflight")
		" call s:vim_set_custom_colorscheme("gruvbox")
		" call s:vim_set_custom_colorscheme("one")
	endif
else
	call s:vim_set_custom_colorscheme("gruvcase")
	" call s:vim_set_custom_colorscheme("onehalflight")
	" call s:vim_set_custom_colorscheme("gruvbox")
	" call s:vim_set_custom_colorscheme("one")
endif

if isdirectory('./include')
	set path+=include
elseif isdirectory('./src/include')
	set path+=src/include
endif

set pastetoggle=<F4>


function! ToggleMouse()
	" check if mouse is enabled
	if &mouse == 'a'
		" disable mouse
		set mouse=
	else
		" enable mouse everywhere
		set mouse=a
	endif
endfunc

nnoremap <C-g> :call ToggleMouse()<CR>
map <C-v> <C-a>
" set clipboard=unnamed

nnoremap <S-k> :tabp<CR>
nnoremap <S-l> :tabn<CR>
nnoremap <S-h> :bp<CR>
nnoremap <S-j> :bn<CR>
nnoremap t[ :tabp<CR>
nnoremap t] :tabn<CR>
nnoremap b[ :bp<CR>
nnoremap b] :bn<CR>


