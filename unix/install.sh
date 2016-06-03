#!/bin/bash

export ORIGINAL_PATH=`pwd`
VIMFILES_PATH=$ORIGINAL_PATH/vimfiles
BUNDLE_PATH=$VIMFILES_PATH/bundle

echo "Current Path: $ORIGINAL_PATH"
echo "Check and install Vundle."

# if we don't have folder vimfiles, create it.
if [ ! -d "./vimfiles/" ]; then
    mkdir ./vimfiles/
fi
cd $VIMFILES_PATH

# if we don't have bundle, create it.
if [ ! -d "./bundle/" ]; then
    mkdir ./bundle/
fi
cd $BUNDLE_PATH

# remove link vim_plugins out to enable it by default
ALL_EXT_PLUGINS=`ls vim_plugins`
for ext_plugins in $ALL_EXT_PLUGINS;
do
  rm $ext_plugins
done

# download or update vundle in ./vimfiles/bundle/
if [ ! -d "./Vundle.vim/" ]; then
    git clone https://github.com/gmarik/Vundle.vim Vundle.vim
fi

# download and install bundles through Vundle in this repository
echo "Update vim-plugins."
cd ${ORIGINAL_PATH}
vim -u .vimrc.mini --cmd "set rtp=./vimfiles,\$VIMRUNTIME,./vimfiles/after" +PluginClean +PluginUpdate +qall

# go back
cd ${ORIGINAL_PATH}


# Set pathogen
mkdir -p "$VIMFILES_PATH/autoload"
cd "$VIMFILES_PATH/autoload"
if [ -f "$VIMFILES_PATH/bundle/vim-pathogen/autoload/pathogen.vim" ]
then
  ln -sf ../bundle/vim-pathogen/autoload/pathogen.vim ./
fi
cd ${ORIGINAL_PATH}

# link vim_plugins out to enable it by default
cd $BUNDLE_PATH
ALL_EXT_PLUGINS=`ls vim_plugins`
for ext_plugins in $ALL_EXT_PLUGINS;
do
  ln -sf vim_plugins/$ext_plugins
done
cd ${ORIGINAL_PATH}


cd $BUNDLE_PATH/YouCompleteMe
./install --clang-completer --omnisharp-completer
cd ${ORIGINAL_PATH}


#
echo "|"
echo "exVim installed successfully!"
echo "|"
echo "You can run 'sh unix/gvim.sh' to preview exVim."
echo "You can also run 'sh unix/replace-my-vim.sh' to replace exVim with your Vim."
