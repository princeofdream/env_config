
let g:custom_plugin_base_path=g:vim_pm_plugins_path."vim_plugins/"

	Plug 'princeofdream/vim_plugins'

	Plug g:custom_plugin_base_path.'vim-l9'
	" " Plug 'vim-fuzzyfinder'
	Plug g:custom_plugin_base_path.'vim-fuzzyfinder'
		function TabnewFufFile()
			 :tabnew
			 :FufFile
		endfunction

		nnoremap tg :call TabnewFufFile()<CR>
		nnoremap tt :FufFile<CR>
		nnoremap tb :FufBuffer<CR>
	Plug g:custom_plugin_base_path.'calendar-vim'
	" Plug g:custom_plugin_base_path.'buftabs.vim'
	Plug g:custom_plugin_base_path.'gtags.vim'
		let GtagsCscope_Auto_Load = 1
		let CtagsCscope_Auto_Map = 1
		let GtagsCscope_Quiet = 1


let g:enable_plugin_taglist = "false"
if g:enable_plugin_taglist == "true"
	Plug g:custom_plugin_base_path.'taglist'
		" nnoremap <unique> <silent> <F4> :TlistToggle<CR>

		" let Tlist_Ctags_Cmd = $VIM.'/vimfiles/ctags.exe' " location of ctags tool
		" let Tlist_Show_One_File = 1 " Displaying tags for only one file~
		" let Tlist_Exist_OnlyWindow = 1 " if you are the last, kill yourself
		" let Tlist_Use_Right_Window = 1 " split to the right side of the screen
		" let Tlist_Sort_Type = "order" " sort by order or name
		" let Tlist_Display_Prototype = 0 " do not show prototypes and not tags in the taglist window.
		" let Tlist_Compart_Format = 1 " Remove extra information and blank lines from the taglist window.
		" let Tlist_GainFocus_On_ToggleOpen = 1 " Jump to taglist window on open.
		" let Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
		" let Tlist_Close_On_Select = 0 " Close the taglist window when a file or tag is selected.
		" let Tlist_BackToEditBuffer = 0 " If no close on select, let the user choose back to edit buffer or not
		" let Tlist_Enable_Fold_Column = 0 " Don't Show the fold indicator column in the taglist window.
		" let Tlist_WinWidth = 40
		" let Tlist_Compact_Format = 1 " do not show help
		""""""""""""""""""""""""""""""""""""""""""""""""""""
			let Tlist_Ctags_Cmd='ctags'
			let Tlist_Show_One_File=0
			let Tlist_Exit_OnlyWindow=1
			let Tlist_Use_Right_Window=0
			let Tlist_Sort_Type='name'
			let Tlist_Show_Menu=1
			let Tlist_Use_SingleClick=0
			let Tlist_Auto_Open=0
			let Tlist_Close_On_Select=0
			let Tlist_File_Fold_Auto_Close=1
			let Tlist_GainFocus_On_ToggleOpen=0
			let Tlist_Process_File_Always=1
			let Tlist_Compact_Format=1
			let Tlist_GainFocus_On_ToggleOpen = 1
			let Tlist_Inc_Winwidth=1
			let Tlist_WinHeight=0
		""""""""""""""""""""""""""""""""""""""""""""""""""""

		" let Tlist_Ctags_Cmd = 'ctags --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++'
		" very slow, so I disable this
		" let Tlist_Process_File_Always = 1 " To use the :TlistShowTag and the :TlistShowPrototype commands without the taglist window and the taglist menu, you should set this variable to 1.
		":TlistShowPrototype [filename] [linenumber]
endif


" exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/ZoomWin'
" exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/project.vim'
" exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/AfterColors.vim'
" exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/Align'
" exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/surround'
" exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/FindMate'

	Plug g:custom_plugin_base_path.'a.vim'


" exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/CountJump'
" exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/fencview'
" let g:fencview_autodetect = 1
" let g:fencview_checklines = 10 "detect 10 line to find out file codec

" " exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/AutoComplPop'
" " exec 'set rtp+=$HOME/.vim/bundle/vim_plugins/omnicppcomplete'


" " " showmarks: invoke by m... or <leader>mm, <leader>ma
" " " ---------------------------------------------------
" " nnoremap <F8> :marks<CR>
" " " " TODO: bootleq/ShowMarks on github is well organized in code, but have lots
" " " " bugs, consider merge his code and fixes the bugs
" " let g:showmarks_enable = 1
" " let g:showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
" " let g:showmarks_ignore_type = 'hqm' " Ignore help, quickfix, non-modifiable buffers
" " " Hilight lower & upper marks
" " let g:showmarks_hlline_lower = 1
" " let g:showmarks_hlline_upper = 0



" " add javascript language
" let tlist_javascript_settings = 'javascript;v:global variable:0:0;c:class;p:property;m:method;f:function;r:object'
" " add hlsl shader language
" let tlist_hlsl_settings = 'c;d:macro;g:enum;s:struct;u:union;t:typedef;v:variable;f:function'
" " add actionscript language
" let tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'

" "}}}

" " map <F8> :call Autopep8()<CR> :w<CR> :call RunPython()<CR>
" " nnoremap <F8> :call RunPython()<CR>
" function RunPython()
    " let mp = &makeprg
    " let ef = &errorformat
    " let exeFile = expand("%:t")
    " setlocal makeprg=python\ -u
    " set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    " silent make %
    " copen
    " let &makeprg = mp
    " let &errorformat = ef
" endfunction

" func! RunCommand()
	" if &filetype == 'c'
		" :AsyncRun ./%<
	" elseif &filetype == 'cpp'
		" :AsyncRun ./%<
	" elseif &filetype == 'java'
		" :AsyncRun java %<
	" elseif &filetype == 'sh'
		" :AsyncRun ./%
	" elseif &filetype == 'py'
		" :AsyncRun python %<
	" endif
" endfunc

" nnoremap <F8> :call RunCommand()<CR>


" func! CompileRunGcc()
	" exec "w"
	" if &filetype == 'c'
		" :AsyncRun g++ % -o %<
		" :AsyncRun ./%<
	" elseif &filetype == 'cpp'
		" :AsyncRun g++ % -o %<
		" :AsyncRun ./%<
	" elseif &filetype == 'java'
		" :AsyncRun javac %
		" :AsyncRun java %<
	" elseif &filetype == 'sh'
		" :AsyncRun ./%
	" elseif &filetype == 'py'
		" :AsyncRun python %
		" :AsyncRun python %<
	" endif
" endfunc

" " nnoremap <F9> :call CompileRunGcc()<CR>



