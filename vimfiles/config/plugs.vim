" Plug '~/vimrc/prototype-plugin'

" =======================================================
""""" Vim Package Manager

" "----------------------------------------------------------------------- "
" "--- Basic library"
" "----------------------------------------------------------------------- "
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'
	" {{{
		" Mapping selecting mappings
		nmap <leader><tab> <plug>(fzf-maps-n)
		xmap <leader><tab> <plug>(fzf-maps-x)
		omap <leader><tab> <plug>(fzf-maps-o)

		" Insert mode completion
		imap <c-x><c-k> <plug>(fzf-complete-word)
		imap <c-x><c-f> <plug>(fzf-complete-path)
		imap <c-x><c-j> <plug>(fzf-complete-file-ag)
		imap <c-x><c-l> <plug>(fzf-complete-line)

		" Advanced customization using autoload functions
		inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
		" Replace the default dictionary completion with fzf-based fuzzy
		" completion
		" inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')
	" }}}
	Plug 'inkarkat/vim-ingo-library'
	Plug 'vim-scripts/LargeFile'


" "----------------------------------------------------------------------- "
" "--- Search"
" "----------------------------------------------------------------------- "
" {{{
	Plug 'asenac/vim-opengrok'
	" {{{
		let g:opengrok_jar = $HOME . '/Environment/web_base/opengrok/lib/opengrok.jar'
		" let g:opengrok_config_file = $HOME . '/Environment/web_base/opengrok/etc/configuration.xml'
		let g:opengrok_config_file = $HOME . '/.opengrok/conf.xml'
		" let g:opengrok_ctags = '/path/to/ctags'
	" }}}
	Plug 'easymotion/vim-easymotion'
	" {{{
		map <leader><leader>/ <Plug>(easymotion-sn)
		omap <leader><leader>/ <Plug>(easymotion-tn)

		map <Leader><Leader>j <Plug>(easymotion-bd-jk)
		nmap <Leader><Leader>j <Plug>(easymotion-overwin-line)
		map <Leader><Leader>k <Plug>(easymotion-bd-jk)
		nmap <Leader><Leader>k <Plug>(easymotion-overwin-line)
		" map <leader><leader>j <Plug>(easymotion-j)
		" map <leader><leader>k <Plug>(easymotion-k)
		map <leader><leader>l <Plug>(easymotion-lineforward)
		map <leader><leader>h <Plug>(easymotion-linebackward)
		let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
	" }}}
	Plug 'dyng/ctrlsf.vim'
		nnoremap <Leader>cf :CtrlSFToggle<CR>
	" "vim plugin
	Plug 'mileszs/ack.vim'
		nnoremap <Leader>a :Ack!<Space>
	" "command
	Plug 'beyondgrep/ack2'
	Plug 'ggreer/the_silver_searcher'
	" {{{
		if executable('ag')
			let g:ackprg = 'ag --vimgrep'
		endif
	" }}}
" }}}


" "----------------------------------------------------------------------- "
" "--- Buffer and files"
" "----------------------------------------------------------------------- "
" {{{
	" Plug 'ctrlpvim/ctrlp.vim'
	"" {{{
	"     nmap <unique> <leader>bf :CtrlPBuffer<CR>
	"     let g:ctrlp_map = '<c-p>'
	"     let g:ctrlp_cmd = 'CtrlP'
	"     let g:ctrlp_working_path_mode = 'a'
	"     if WINDOWS()
	"         set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
	"         let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
	"     else
	"         set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
	"         let g:ctrlp_user_command = 'find . %s -type f'        " MacOSX/Linux
	"     endif

	"     let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
	"     let g:ctrlp_custom_ignore = {
	"       \ 'dir':  '\v[\/]\.(git|hg|svn)$',
	"       \ 'file': '\v\.(exe|so|dll)$',
	"       \ 'link': 'some_bad_symbolic_links',
	"       \ }
	"     let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']
	"     let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
	"     let g:ctrlp_user_command = ['.hg', 'hg --cwd %s locate -I .']
	"     let g:ctrlp_user_command = {
	"         \ 'types': {
	"             \ 1: ['.git', 'cd %s && git ls-files'],
	"             \ 2: ['.hg', 'hg --cwd %s locate -I .'],
	"         \ },
	"         \ 'fallback': 'find %s -type f'
	"     \ }
	"" }}}

	" Plug 'tacahiroy/ctrlp-funky'
	" {{{
	"     nnoremap tf :CtrlPFunky<Cr>
	"     " narrow the list down with a word under cursor
	"     nnoremap tu :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
	"     let g:ctrlp_funky_matchtype = 'path'
	"     let g:ctrlp_funky_syntax_highlight = 1
	"     let g:ctrlp_extensions = ['funky']
	" }}}

	Plug 'Yggdroot/LeaderF'
	" {{{
		let g:Lf_CommandMap = {'<Tab>': ['<ESC>']}
		highlight Lf_hl_match gui=bold guifg=Blue cterm=bold ctermfg=21
		highlight Lf_hl_matchRefine  gui=bold guifg=Magenta cterm=bold ctermfg=201
		let g:Lf_ShortcutF = '<C-P>'
	" }}}


	Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle', 'tag': '*' }
	" {{{
		map <unique> <F2> :NERDTreeToggle<CR>
		map <C-n> :NERDTreeToggle<CR>
		" autocmd vimenter * exe 'NERDTree'
		autocmd StdinReadPre * let s:std_in=1
		" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
		" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'NERDTree' | endif
		" close vim if the only window left open is a NERDTree
		autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
		let g:NERDTreeDirArrowExpandable = '▸'
		let g:NERDTreeDirArrowCollapsible = '▾'
	" }}}
	Plug 'jlanzarotta/bufexplorer'
	Plug 'jeetsukumaran/vim-buffergator'
	" Plug 'fholgado/minibufexpl.vim'
	Plug 'majutsushi/tagbar'
	" {{{
		map <F3> :TagbarToggle<CR>
		" let g:tagbar_sort = 0
		" let g:tagbar_map_preview = '<CR>'
		" if has('gui_running')
		"     let g:tagbar_map_close = '<Esc>'
		" else
		"     let g:tagbar_map_close = '<leader><Esc>'
		" endif
		" let g:tagbar_map_zoomwin = '<Space>'
		" let g:tagbar_zoomwidth = 80
		" let g:tagbar_autofocus = 1
		" let g:tagbar_iconchars = ['+', '-']

		" " use command ':TagbarGetTypeConfig lang' change your settings
		" let g:tagbar_type_javascript = {
		"     \ 'ctagsbin': 'ctags',
		"     \ 'kinds' : [
		"         \ 'v:global variables:0:0',
		"         \ 'c:classes',
		"         \ 'p:properties:0:0',
		"         \ 'm:methods',
		"         \ 'f:functions',
		"         \ 'r:object',
		"     \ ],
		" \ }
		" let g:tagbar_type_c = {
		"     \ 'kinds' : [
		"         \ 'd:macros:0:0',
		"         \ 'p:prototypes:0:0',
		"         \ 'g:enums',
		"         \ 'e:enumerators:0:0',
		"         \ 't:typedefs:0:0',
		"         \ 's:structs',
		"         \ 'u:unions',
		"         \ 'm:members:0:0',
		"         \ 'v:variables:0:0',
		"         \ 'f:functions',
		"     \ ],
		" \ }
		" let g:tagbar_type_cpp = {
		"     \ 'kinds' : [
		"         \ 'd:macros:0:0',
		"         \ 'p:prototypes:0:0',
		"         \ 'g:enums',
		"         \ 'e:enumerators:0:0',
		"         \ 't:typedefs:0:0',
		"         \ 'n:namespaces',
		"         \ 'c:classes',
		"         \ 's:structs',
		"         \ 'u:unions',
		"         \ 'f:functions',
		"         \ 'm:members:0:0',
		"         \ 'v:variables:0:0',
		"     \ ],
		" \ }
	" }}}

	Plug 'NLKNguyen/easy-navigate.vim'
	"{{{
		" ]b	Go to next buffer	:bnext
		" [b	Go to previous buffer	:bprevious
		" ]B	Go to last buffer	:blast
		" [B	Go to first buffer	:bfirst
		" ]t	Go to next tab	:tabnext
		" [t	Go to previous tab	:tabprevious
		" ]T	Go to last tab	:tablast
		" [T	Go to first tab		:tabfirst
		" <leader>`	Open a new tab	:tabnew
		" <leader>1	Go to tab #1	1gt
	" }}}
	" file encoding auto detect
	Plug 's3rvac/AutoFenc'
	" Plug 'mbbill/fencview'
" }}}


" "----------------------------------------------------------------------- "
" "--- Align"
" "----------------------------------------------------------------------- "
" """" tabular must comes before markdown
	" Plug 'junegunn/vim-easy-align'
	Plug 'godlygeek/tabular'
		nnoremap <silent> <leader>= :call g:Tabular(1)<CR>
		xnoremap <silent> <leader>= :call g:Tabular(0)<CR>
		function! g:Tabular(ignore_range) range
			let c = getchar()
			let c = nr2char(c)
			if a:ignore_range == 0
				exec printf('%d,%dTabularize /%s', a:firstline, a:lastline, c)
			else
				exec printf('Tabularize /%s', c)
			endif
		endfunction
	Plug 'plasticboy/vim-markdown'
	" Plug 'iamcco/markdown-preview.nvim'
	" {{{
		" " set to 1, the nvim will open the preview window once enter the markdown buffer
		" " default: 0
		" let g:mkdp_auto_start = 0

		" " set to 1, the nvim will auto close current preview window when change
		" " from markdown buffer to another buffer
		" " default: 1
		" let g:mkdp_auto_close = 1

		" " set to 1, the vim will just refresh markdown when save the buffer or
		" " leave from insert mode, default 0 is auto refresh markdown as you edit or
		" " move the cursor
		" " default: 0
		" let g:mkdp_refresh_slow = 0

		" " set to 1, the MarkdownPreview command can be use for all files,
		" " by default it just can be use in markdown file
		" " default: 0
		" let g:mkdp_command_for_global = 0

		" " set to 1, preview server available to others in your network
		" " by default, the server only listens on localhost (127.0.0.1)
		" " default: 0
		" let g:mkdp_open_to_the_world = 0

		" " use custom IP to open preview page
		" " useful when you work in remote vim and preview on local browser
		" " more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
		" " default empty
		" let g:mkdp_open_ip = ''

		" " specify browser to open preview page
		" " default: ''
		" let g:mkdp_browser = ''

		" " set to 1, echo preview page url in command line when open preview page
		" " default is 0
		" let g:mkdp_echo_preview_url = 0

		" " a custom vim function name to open preview page
		" " this function will receive url as param
		" " default is empty
		" let g:mkdp_browserfunc = ''

		" " options for markdown render
		" " mkit: markdown-it options for render
		" " katex: katex options for math
		" " uml: markdown-it-plantuml options
		" " maid: mermaid options
		" " disable_sync_scroll: if disable sync scroll, default 0
		" " sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
		" "   middle: mean the cursor position alway show at the middle of the preview page
		" "   top: mean the vim top viewport alway show at the top of the preview page
		" "   relative: mean the cursor position alway show at the relative positon of the preview page
		" let g:mkdp_preview_options = {
		"     \ 'mkit': {},
		"     \ 'katex': {},
		"     \ 'uml': {},
		"     \ 'maid': {},
		"     \ 'disable_sync_scroll': 0,
		"     \ 'sync_scroll_type': 'middle'
		"     \ }

		" " use a custom markdown style must be absolute path
		" let g:mkdp_markdown_css = ''

		" " use a custom highlight style must absolute path
		" let g:mkdp_highlight_css = ''

		" " use a custom port to start server or random for empty
		" let g:mkdp_port = ''

		" " preview page title
		" " ${name} will be replace with the file name
		" let g:mkdp_page_title = '「${name}」'
	" }}}


" "----------------------------------------------------------------------- "
" "--- undo"
" "----------------------------------------------------------------------- "
	Plug 'mbbill/undotree'
	" {{{
		nnoremap <leader>u :UndotreeToggle<CR>
		nnoremap <F6> :UndotreeToggle<CR>
		let g:undotree_SetFocusWhenToggle=1
		let g:undotree_WindowLayout = 4
		" NOTE: this will prevent undotree closed then jump to minibufexpl
		function! g:CloseUndotree()
			call UndotreeHide()
			call ex#window#goto_edit_window()
		endfunction
		function g:Undotree_CustomMap()
			if has('gui_running')
				nnoremap <silent> <script> <buffer> <ESC> :call g:CloseUndotree()<CR>
			else
				nnoremap <silent> <script> <buffer> <leader><ESC> :call g:CloseUndotree()<CR>
			endif
		endfunction
	" }}}
	" Plug 'sjl/gundo.vim'

" "----------------------------------------------------------------------- "
" "--- auto complete"
" "----------------------------------------------------------------------- "
" {{{
	" let g:vim_custom_snippets = "UltiSnips"
	if has('python3')
		let g:vim_custom_snippets = "UltiSnips"
	else
		let g:vim_custom_snippets = "snipmate"
	endif
	if g:vim_custom_snippets == "UltiSnips"
		" {{{
		Plug 'SirVer/UltiSnips' | Plug 'honza/vim-snippets'
		" {{{
			" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
			let g:UltiSnipsExpandTrigger="<tab>"
			let g:UltiSnipsJumpForwardTrigger="<c-b>"
			let g:UltiSnipsJumpBackwardTrigger="<c-f>"

			" If you want :UltiSnipsEdit to split your window.
			let g:UltiSnipsEditSplit="vertical"
		" }}}
	" }}}
	elseif g:vim_custom_snippets == "snipmate"
		Plug 'msanders/snipmate.vim'
	endif
	" {{{
		" Plug 'tenfyzhong/CompleteParameter.vim'
		" " Plug 'Shougo/neocomplete.vim'
		" Plug 'Shougo/deoplete.nvim'
		" Plug 'zchee/deoplete-clang'
		" Plug 'fatih/vim-go', { 'tag': '*', 'for': ['go', 'golang'] }
		" Plug 'zchee/deoplete-jedi'
		" Plug 'sebastianmarkow/deoplete-rust'
		" Plug 'carlitux/deoplete-ternjs'
		" Plug 'mhartington/nvim-typescript'
		" Plug 'johnzeng/vim-erlang-omnicomplete'

		" " vim snippets selete one of it
		" " 2.
		" " 3.
		" Plug 'MarcWeber/vim-addon-mw-utils'
		" Plug 'tomtom/tlib_vim'
		" Plug 'garbas/vim-snipmate'
		" " Plug 'honza/vim-snippets'
		" "
		" " Plug 'spf13/snipmate-snippets'
	" }}}

	" ------- YCM clang_complete depolete
	" {{{
		let g:use_complete_tool = "none"
		" let g:use_complete_tool = "depolete"
		" let g:use_complete_tool = "clang_complete"
		" let g:use_complete_tool = "YCM"
		set completeopt-=preview
	" }}}

	"" " Check omnifunc and completefunc"
	"" check command will be : ":set omnifunc? completefunc?"
	"" Clang: omnifunc --> ClangComplete
	"" Clang: completefunc --> ClangComplete
	"" YCM: omnifunc --> <???>
	"" YCM: completefunc --> YouCompleteMe#CompleteFunction


	" Plug 'Valloric/YouCompleteMe'
	" Plug 'Rip-Rip/clang_complete'
	" Plug 'artur-shaik/vim-javacomplete2'
	" {{{
		" autocmd FileType java setlocal omnifunc=javacomplete#Complete
		" let g:JavaComplete_MavenRepositoryDisable = 1
		" let g:JavaComplete_EnableDefaultMappings = 0
	" }}}

	if g:use_complete_tool == "YCM"
		" {{{
		" "----------------------------- YourCompleteMe --------------------------"
		" "YCM是vim的一款基于语义的智能补全插件。该插件的功能与以下插件相冲突："
		" "- clang_complete"
		" "- AutoComplPop"
		" "- Supertab"
		" "----------------------------------------------------------------------- "
		Plug 'Valloric/YouCompleteMe'
		" {{{
			let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
			let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
			let g:ycm_key_invoke_completion = '<C-e>'

			let g:ycm_confirm_extra_conf=0 "关闭加载.ycm_extra_conf.py提示
			let g:ycm_collect_identifiers_from_tags_files=1	" 开启 YCM 基于标签引擎
			let g:ycm_min_num_of_chars_for_completion=2	" 从第2个键入字符就开始罗列匹配项
			let g:ycm_cache_omnifunc=1	" 禁止缓存匹配项,每次都重新生成匹配项
			let g:ycm_seed_identifiers_with_syntax=1	" 语法关键字补全
			" nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>	"force recomile with syntastic
			"nnoremap <leader>lo :lopen<CR>	"open locationlist
			"nnoremap <leader>lc :lclose<CR>	"close locationlist
			" inoremap <leader><leader> <C-x><C-o>
			"在注释输入中也能补全
			let g:ycm_complete_in_comments = 1
			" "在字符串输入中也能补全
			let g:ycm_complete_in_strings = 1
			" "注释和字符串中的文字也会被收入补全
			let g:ycm_collect_identifiers_from_comments_and_strings = 0
			let g:ycm_server_python_interpreter=$HOME . '/Environment/env_rootfs/bin/python'
			let g:ycm_python_binary_path = 'python'
			let g:ycm_global_ycm_extra_conf=$HOME . '/.ycm_extra_conf.py'

			let g:ycm_autoclose_preview_window_after_completion = 1
			let g:ycm_autoclose_preview_window_after_insertion = 1
			let g:ycm_use_ultisnips_completer = 1
			" nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
			nnoremap <leader>gf :YcmCompleter GoToDefinitionElseDeclaration<CR>
		" }}}

		Plug 'rdnetto/YCM-Generator'
	" }}}
	elseif g:use_complete_tool == "depolete"
	" {{{
		" "--------------------------- deoplete --------------------------"
		Plug 'Shougo/deoplete.nvim'
		let g:deoplete#enable_at_startup = 1
		" Plugin 'zchee/deoplete-clang'
		" Plugin 'fatih/vim-go'
		" Plugin 'zchee/deoplete-jedi'
		" Plugin 'sebastianmarkow/deoplete-rust'
		" Plugin 'carlitux/deoplete-ternjs'
		" Plugin 'mhartington/nvim-typescript'
	" }}}
	elseif g:use_complete_tool == "clang_complete"
	" {{{
		" "--------------------------- Clang Complete --------------------------"
		Plug 'Rip-Rip/clang_complete'
		" "open quick fix window false
		" let g:clang_debug=1
		let g:clang_periodic_quickfix=0
		let g:clang_complete_copen=1
		let g:clang_snippets=1
		let g:clang_close_preview=1
		let g:clang_user_options='-stdlib=libc++ -std=c++11 -IIncludePath'
		" let g:clang_auto_user_options="path, .clang_complete"

		let g:clang_use_library=1
		" let g:clang_library_path='/usr/lib64/llvm'
		let g:clang_library_path=$HOME . '/Environment/env_rootfs/lib/libclang.so'
		" let g:clang_library_path="F:/clang/lib"

		"" let g:clang_use_library=0
		"" let g:clang_exec="clang"
		"" let g:clang_exec="clang.exe"

		let g:clang_hl_errors=1
		let g:clang_auto_select=1
		let g:clang_complete_auto=1
		let g:clang_snippets=1
		let g:clang_snippets_engine="clang_complete"
		let g:clang_conceal_snippets=0
		let g:clang_sort_algo="priority"
		let g:clang_complete_macros=1
		let g:clang_complete_patterns=1
		" autocmd FileType c setlocal omnifunc=ccomplete#Complete
		" autocmd FileType cpp setlocal omnifunc=ccomplete#Complete
	" }}}
	endif

	"" automatic closing of quotes, parenthesis, brackets, etc.
	" Plug 'Raimondi/delimitMate'
	" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' , 'for': ['go', 'golang']}
	Plug 'Shougo/echodoc.vim'


" "----------------------------------------------------------------------- "
" "--- colorschemes"
" "----------------------------------------------------------------------- "
	" Bottom line
	" {{{
		let g:vim_custom_status_line = "lightline"
		" let g:vim_custom_status_line = "airline"
		" let g:vim_custom_status_line = "powerline"
		" let g:vim_custom_status_line = "bufferline"
		" let g:vim_custom_status_line = "none"
	" }}}

	if g:vim_custom_status_line == "lightline"
	" {{{
		Plug 'itchyny/lightline.vim'
		" {{{
			" [ 'gitbranch', 'readonly', 'filename', 'modified', 'buffers' ] ]
			let g:lightline = {
					\ 'colorscheme': 'one',
					\ 'separator': { 'left': '', 'right': '' },
					\ 'subseparator': { 'left': '', 'right': '' },
					\ 'active': {
					\     'left': [
					\             [ 'mode', 'paste' ],
					\             [ 'gitbranch' ],
					\             [ 'modified', 'readonly' ],
					\             [ 'buffers' ] ],
					\     'right': [
					\			  ['lineinfo'],
					\			  ['percent'],
					\			  ['fileformat', 'fileencoding', 'filetype'] ]
					\ },
					\ 'inactive': {
					\     'left': [['filename']],
					\     'right': [['lineinfo'], ['percent']]
					\   },
					\ 'tabline': {
					\     'left': [['tabs']],
					\     'right': [['close']]
					\ },
					\ 'tab': {
					\     'active': ['tabnum', 'filename', 'modified'],
					\     'inactive': ['tabnum', 'filename', 'modified']
					\ },
					\ 'component_function': {
					\     'gitbranch': 'fugitive#head',
					\     'filestat': 'LightlineFilestat'
					\ },
			\ }
			function! LightlineFilestat()
				let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
				let modified = &modified ? ' +' : ''
				return filename . modified
			endfunction
		" }}}
	" }}}
	elseif g:vim_custom_status_line == "airline"
	" {{{
		Plug 'vim-airline/vim-airline'
		" {{{
			" highlight bufferline_selected gui=bold cterm=bold term=bold guibg=#c678dd guifg=#273074
			let g:airline#extensions#tabline#enabled = 1 " NOTE: When you open lots of buffers and typing text, it is so slow.
			let g:airline#extensions#tabline#left_sep = ''
			let g:airline#extensions#tabline#left_alt_sep = ''
			let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
			let g:airline#extensions#tabline#show_tab_nr = 1
			let g:airline#extensions#tabline#formatter = 'default'
			let g:airline#extensions#tabline#buffer_nr_show = 0
			let g:airline#extensions#tabline#fnametruncate = 16
			let g:airline#extensions#tabline#fnamecollapse = 2
			let g:airline#extensions#tabline#buffer_idx_mode = 1
		" }}}

		Plug 'vim-airline/vim-airline-themes'
	" }}}
	elseif g:vim_custom_status_line == "powerline"
	" {{{
		if (!has("nvim"))
			let vim_plugins_enable_powerline=1
			if (vim_plugins_enable_powerline)
				Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim'}
			endif
		else
			Plug 'itchyny/lightline.vim'
		endif
	" }}}
	elseif g:vim_custom_status_line == "bufferline"
	" {{{
		Plug 'bling/vim-bufferline'
			" let g:bufferline_echo = 1
			" let g:bufferline_show_bufnr = 0
	" }}}
	endif
	Plug 'upsuper/vim-colorschemes'
	Plug 'rakr/vim-one'
	Plug 'morhetz/gruvbox'
	" Plug 'jeaye/color_coded'
	" Plug 'nathanaelkane/vim-indent-guides' "Display tab and space in front of a line
	" Plug 'Yggdroot/indentLine' "Display tab and space with |
	Plug 'kien/rainbow_parentheses.vim' " Rainbow pair () [] {} etc

	Plug 'powerline/fonts'
	Plug 'chase/focuspoint-vim'
	Plug 'tomasr/molokai'
		" let g:molokai_original = 1
		" let g:rehash256 = 1
	Plug 'drewtempelmeyer/palenight.vim'
	Plug 'ayu-theme/ayu-vim'
	Plug 'arcticicestudio/nord-vim' , {'tag': '*'}
	Plug 'mhartington/oceanic-next'
	Plug 'romainl/flattened'
	Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
	Plug 'jaxbot/semantic-highlight.vim'
	" {{{
		nnoremap <Leader>s :SemanticHighlightToggle<cr>
		let s:semanticGUIColors = [ '#72d572', '#c5e1a5', '#e6ee9c', '#fff59d', '#ffe082', '#ffcc80', '#ffab91', '#bcaaa4', '#b0bec5', '#ffa726', '#ff8a65', '#f9bdbb', '#f9bdbb', '#f8bbd0', '#e1bee7', '#d1c4e9', '#ffe0b2', '#c5cae9', '#d0d9ff', '#b3e5fc', '#b2ebf2', '#b2dfdb', '#a3e9a4', '#dcedc8' , '#f0f4c3', '#ffb74d' ]
		let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,16,125,124,19]
	" }}}
	Plug 'mhinz/vim-startify'

	Plug 'rubberduck203/aosp-vim'
" }}}


" "----------------------------------------------------------------------- "
" "--- Actions"
" "----------------------------------------------------------------------- "
" {{{
	Plug 'tpope/vim-repeat'
	Plug 'ntpeters/vim-better-whitespace'
	" {{{
		"" remove end whitespace
		"":s/\s\+$//
		nnoremap <unique> <leader>w :s/\s\+$//<CR>
		nnoremap <unique> <leader>W :%s/\s\+$//<CR>
		let g:better_whitespace_enabled=1
		let g:strip_whitespace_on_save=0
		let g:better_whitespace_ctermcolor='62'
		let g:better_whitespace_guicolor='#5f5fd7'
		let g:strip_whitespace_confirm=1
		" nnoremap <unique> <leader>w :StripWhitespace<CR>
		" Plugin 'bronson/vim-trailing-whitespace'
		"nnoremap <unique> <leader>w :FixWhitespace<CR>
	" }}}
	" Plug 'yonchu/accelerated-smooth-scroll'
	" Plug 'terryma/vim-smooth-scroll'
	" Plug 'tpope/vim-surround'
	" Plug 'tmhedberg/SimpylFold'
	" Plug 'chrisbra/NrrwRgn' " Narrow to edit part of code
	" Plug 'terryma/vim-multiple-cursors'
	" " Plug 'dhruvasagar/vim-table-mode'
	" " Plug 'ervandew/supertab'
	Plug 'MattesGroeger/vim-bookmarks'
	" {{{
		" let g:bookmark_no_default_key_mappings = 1
		" highlight BookmarkSign ctermbg=NONE ctermfg=160
		" highlight BookmarkLine ctermbg=194 ctermfg=NONE
		" let g:bookmark_sign = '♥'
		let g:bookmark_sign = '♥'
		let g:bookmark_highlight_lines = 1
		let g:bookmark_disable_ctrlp = 1
		let g:bookmark_auto_save = 1
		let g:bookmark_annotation_sign = '>>'
		let g:bookmark_auto_close = 1
	" }}}
	Plug 'Valloric/ListToggle'
	" {{{
		" <leader>l <leader>q
		let g:lt_location_ulist_toggle_map = '<leader>l'
		let g:lt_quickfix_list_toggle_map = '<leader>q'
		let g:lt_height = 10
	" }}}
	Plug 'yonchu/accelerated-smooth-scroll'
	" {{{
		nmap <silent> <C-i> <Plug>(ac-smooth-scroll-c-d)
	" }}}
	Plug 'danro/rename.vim'
		" :rename {xxx}
	Plug 'gcmt/wildfire.vim'
	" {{{
		let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it"]
		let g:wildfire_objects = {
		    \ "*" : ["i'", 'i"', "i)", "i]", "i}"],
		    \ "html,xml" : ["at", "it"],
			\ }
		nmap <leader>e <Plug>(wildfire-quick-select)
		" This selects the next closest text object.
		map <SPACE> <Plug>(wildfire-fuel)
		" This selects the previous closest text object.
		vmap <C-SPACE> <Plug>(wildfire-water)
	" }}}
" }}}

" "----------------------------------------------------------------------- "
" "--- commenter"
" "----------------------------------------------------------------------- "
" {{{
	Plug 'scrooloose/nerdcommenter'
	" {{{
		let g:NERDSpaceDelims = 1
		let g:NERDRemoveExtraSpaces = 1
		let g:NERDCompactSexyComs = 1
		" Align line-wise comment delimiters flush left instead of following code indentation
		let g:NERDDefaultAlign = 'left'
		let g:NERDToggleCheckAllLines = 1
		let g:NERDCustomDelimiters = {
					\  'rc': { 'left': '#' },
					\  }
		map <unique> <F10> <plug>NERDCommenterToggle
		map <unique> <F11> <plug>NERDCommenterToggle
	" }}}
	" Plug 'tpope/vim-commentary'
" }}}


" "----------------------------------------------------------------------- "
" "--- command line"
" "----------------------------------------------------------------------- "
" {{{
	Plug 'joonty/vim-do'
	Plug 'osyo-manga/vim-over'
	Plug 'Shougo/vimproc.vim'
	Plug 'Shougo/vimshell.vim'
	" Plug 'skywind3000/asyncrun.vim'
" }}}



" "----------------------------------------------------------------------- "
" "--- filetype support"
" "----------------------------------------------------------------------- "
" {{{
	Plug 'WolfgangMehner/bash-support'    , { 'tag': '*' }
	Plug 'WolfgangMehner/c-support'       , { 'tag': '*' }
	Plug 'WolfgangMehner/git-support'     , { 'tag': '*' }
	Plug 'WolfgangMehner/lua-support'     , { 'tag': '*' }
	Plug 'WolfgangMehner/vim-support'     , { 'tag': '*' }
	Plug 'WolfgangMehner/latex-support'   , { 'tag': '*' }
	Plug 'WolfgangMehner/perl-support'    , { 'tag': '*' }
	Plug 'WolfgangMehner/awk-support'     , { 'tag': '*' }
	Plug 'WolfgangMehner/python-support'
	Plug 'WolfgangMehner/matlab-support'
	Plug 'WolfgangMehner/verilog-support'

	" syntastic check
	let g:vim_custom_syntastic = "ale"

	if g:vim_custom_syntastic == "syntastic"
	" {{{
		Plug 'vim-syntastic/syntastic'
		" {{{
			" this will make html file by Angular.js ignore errors
			let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
			let g:syntastic_javascript_checkers = ['eslint']
			let g:syntastic_error_symbol = '✗' "set error or warning signs
			let g:syntastic_warning_symbol = '⚠'
			let g:syntastic_check_on_open=1
			let g:syntastic_enable_highlighting = 0
			"let g:syntastic_python_checker="flake8,pyflakes,pep8,pylint"
			let g:syntastic_python_checkers=['pyflakes']
			"highlight SyntasticErrorSign guifg=white guibg=black
			let g:syntastic_cpp_include_dirs = ['/usr/include/']
			let g:syntastic_cpp_remove_include_errors = 1
			let g:syntastic_cpp_check_header = 1
			let g:syntastic_cpp_compiler = 'clang++'
			let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
			let g:syntastic_enable_balloons = 1 "whether to show balloons
		" }}}
	" }}}
	elseif g:vim_custom_syntastic == "ale"
	" {{{
		Plug 'w0rp/ale'
		" {{{
			" "in javascript.vim not here
			" " Fix files with prettier, and then ESLint.
			" let b:ale_fixers = ['prettier', 'eslint']
			" " Equivalent to the above.
			" let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
			" "in vimrc
			let g:ale_sign_column_always = 1
			let g:ale_set_highlights = 1
			let g:ale_fixers = {
			\   'javascript': ['eslint'],
			\}
			let g:ale_linters = {
			\   'c++': ['clang'],
			\   'c': ['clang'],
			\   'python': ['pylint'],
			\}
			" Set this variable to 1 to fix files when you save them.
			let g:ale_fix_on_save = 0
			" Enable completion where available.
			let g:ale_completion_enabled = 0
			let g:ale_sign_error = '✗'
			let g:ale_sign_warning = '⚠'
			let g:ale_statusline_format = ['✗ %d', '⚠ %d', '✔ OK']
			nmap [v <Plug>(ale_previous_wrap)
			nmap ]v <Plug>(ale_next_wrap)
			nmap <Leader>d :ALEDetail<CR>
			let g:ale_set_loclist = 0
			let g:ale_set_quickfix = 1
			let g:ale_list_window_size = 5
			let g:ale_keep_list_window_open = 1
			let g:ale_open_list = 0
		" }}}
	" }}}
	endif



	" A collection of language packs for Vim.
	Plug 'sheerun/vim-polyglot'
		let g:polyglot_disabled = ['css']

	" Plug 'mattn/emmet-vim'
	" "----For js
	" Plug 'kchmck/vim-coffee-script'
	" Plug 'ternjs/tern_for_vim'
	" Plug 'pangloss/vim-javascript'
	" "----For Python
	" Plug 'tell-k/vim-autopep8'
	" Plug 'davidhalter/jedi'
	" Plug 'davidhalter/jedi-vim'
	" Plug 'ivanov/vim-ipython'
	" Plug 'hail2u/vim-css3-syntax'
	" Plug 'digitaltoad/vim-jade'
	" Plug 'wavded/vim-stylus'
	" Plug 'groenewege/vim-less'
	" "----For coljure
	" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" }}}

" "----------------------------------------------------------------------- "
" "--- VCS control"
" "----------------------------------------------------------------------- "
" {{{
	Plug 'airblade/vim-gitgutter'
		let g:gitgutter_max_signs=2048
	Plug 'tpope/vim-fugitive'
		" git status --> :Gstatus
		"	- to add/reset
		"   p to add/reset --patch
		" git mv --> :Gmove
		"	move and rename in buffer
		" git grep --> :Ggrep
		autocmd QuickFixCmdPost *grep* cwindow
		" git checkout -- filename --> :Gread
		" git add --> :Gwrite
	Plug 'junegunn/gv.vim'
	" Plug 'mattn/webapi-vim'
	" Plug 'mattn/gist-vim'
	" Plug 'https://github.com/junegunn/vim-github-dashboard.git'
" }}}


" "----------------------------------------------------------------------- "
" "--- Custom"
" "----------------------------------------------------------------------- "
" {{{
" }}}


" "----------------------------------------------------------------------- "
" "--- data collection"
" "----------------------------------------------------------------------- "
" {{{
	Plug 'wakatime/vim-wakatime'
" }}}

" =======================================================






