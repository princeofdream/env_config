# 1. setup runtime

## 1.1. Vim

### 1.1.1. Windows Platform

show runtimepath

```vim
:set runtimepath
```

try to put vimfiles in `D:\Programs\Vim\vimfiles`, `$HOME/vimfiles` etc...


## 1.2. NeoVim

### 1.2.1. Windows Platform

get vimtool path

```vim
set runtimepath
```

change dir to nvim dir and link vimfiles

```
cd C:\tools\neovim\nvim-win64\share\nvim
CMD:
mklink /J vimfiles D:\envx\common_libx\env_config\vimfiles
```


# 2. python support

## 2.1. Windows vim

Download python embed version, unzip to c:/Python312/

```
wget -c https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip
```



