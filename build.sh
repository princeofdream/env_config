#!/bin/sh


TOP=$(pwd)

PREFIX_PATH=$HOME/Environment/env_rootfs


function setup_env()
{
    sudo yum install -y \
        gpm-devel \
        ruby-devel \
        python-devel \
        lua-devel \
        perl-devel

    sudo systemctl restart gpm

    return 0
}




# git clone https://github.com/vim/vim.git

# cd $TOP/vim80


# setup_env


./configure \
    --prefix=$PREFIX_PATH \
    --enable-multibyte \
    --with-features=huge \
    --with-tlib=tinfo \
    --enable-cscope \
    --enable-pythoninterp \
    --with-python-config-dir=/usr/lib64/python2.7/ \
    --enable-rubyinterp \
    --enable-perlinterp=yes \
    --enable-tclinterp=yes \
    --enable-gpm \
    --enable-sysmouse \
    --enable-luainterp=yes \


# --with-python-config-dir=/usr/lib64/python2.7/config
# --enable-python3interp=yes
# --with-python3-config-dir=/usr/lib64/python3.4/



