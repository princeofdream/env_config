
export ORIGINAL_PATH=`pwd`

cd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer
# ./install.py --all
cd $ORIGINAL_PATH
