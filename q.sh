#! /bin/sh
#echo -e "\033[0;36;1m ctags \033[0m\033[0;33;1m -R --c++-kinds=+p --fields=+iaS --extra=+q \033[0m"
#ctags -R --c++-kinds=+p --fields=+iaS --extra=+q

echo -e "[0;36;1m ctags [0m[0;33;1m --extra=+q --fields=+Saim --c++-kinds=+lpx --c-kinds=+lpx -R [0m"
ctags  --extra=+q --fields=+Saim --c++-kinds=+lpx --c-kinds=+lpx  --fields=+lS -R .
#ctags --c++-kinds=+p --fields=+iaS --extra=+q "$@"
#ctags  --extra=+q --fields=+Saim --c++-kinds=+lpx --c-kinds=+lpx -R .
