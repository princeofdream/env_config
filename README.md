basic env setuo

1. env
2. vim
	## Enable python3 support:
	a. Windows
		build:
		binary:
			Download gvim to install to $VIM path
			check vim compile with python version by vim --version
			if python3 version is python36.dll, get python build for win32 with blow url
			https://www.python.org/ftp/python/3.6.8/python-3.6.8-embed-win32.zip
			unzip the file, copy all the file to $VIM directory
	## Enable GUI comple
	a. Ubuntu:
		install the packages below and use --enable-gtk to enable gui build.
			libx11-dev libgtk2.0-dev libncurses-dev libxt-dev
	## Vim file path
	a. Windows
		use vim --version to see default vim file
		$VIM/vimrc, $VIM/_vimrc, $HOME/vimrc, $HOME/vimfiles/vimrc etc.
		change vimrc path to source from vimfiles, for ex:
			let g:vim_pm_path = $HOME . "/.vim/"
			-->
			let g:vim_pm_path = $VIM . "/vimfiles/"
3. tmux
