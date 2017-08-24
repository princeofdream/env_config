#!/bin/sh


TOP=$(pwd)
PREFIX_PATH=$HOME/Environment/env_rootfs

function setup_env_yum()
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


function setup_env_apt()
{
	sudo apt-get install libgpm-dev \
		python-dev \
		lua5.2-dev
	return 0;
}


function configure_vim()
{
	cd $TOP/vim80
./configure \
    --prefix=$PREFIX_PATH \
		--libdir=$PREFIX_PATH/lib \
		--enable-gpm \
    --enable-multibyte \
    --with-features=huge \
    --with-tlib=tinfo \
    --enable-cscope \
    --enable-pythoninterp \
    --enable-rubyinterp \
    --enable-perlinterp=yes \
    --enable-tclinterp=yes \
    --enable-gpm \
    --enable-sysmouse \
    --enable-luainterp=yes \
		--with-python-config-dir=/usr/lib/python2.7/config > log.log 2>err.log
}



function build_gpm()
{
	## gpm
	## https://github.com/telmich/gpm
	## or http://www.nico.schottelius.org/software/gpm/archives/
	cd $TOP
	if [ ! -d $TOP/gpm ]
	then
		git clone https://github.com/telmich/gpm.git
	fi
	cd $TOP/gpm
	git checkout master
	git branch -D 1.20.3
	git checkout 1.20.3 -b 1.20.3
	./autogen.sh
	./configure \
		--prefix=$PREFIX_PATH
	echo "Configure OK!!!"
	find src/ -name "*.c" -o -name "*.h"|xargs sed -i "s/GPM_RELEASE\>/\"1.20.3 by JamesL\"/g"
	find src/ -name "*.c" -o -name "*.h"|xargs sed -i "s/GPM_RELEASE_DATE\>/\"now\"/g"
	make -j8
	make
	make install

}

# --with-python-config-dir=/usr/lib64/python2.7/config
# --enable-python3interp=yes
# --with-python3-config-dir=/usr/lib64/python3.4/







##### main
# git clone https://github.com/vim/vim.git
# cd $TOP/vim80
# setup_env

# build_gpm
configure_vim

