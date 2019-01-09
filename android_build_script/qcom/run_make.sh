#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f "$0"))
TARGET_ARCH=arm64
LUNCH_COMBO=msm8996-eng
NCPUS=12
# TOOLCHAIN=arm-linux-gnueabi-
# TOOLCHAIN=aarch64-none-elf-
TOOLCHAIN=aarch64-linux-android-
KERNEL_C_FLAGS=-mno-android

USER_CONFIG=msm-auto-perf_defconfig
ENG_CONFIG=msm-auto-defconfig

display_help() {
	echo "args will be:
			kernel_menuconfig	:make kernel menuconfig
			kernel_make			:make kernel
			kernel_distclean	:make kernel distclean
			bootimage			:make boot.img
				"
}

kernel_menuconfig() {
	make -C $ANDROID_BUILD_TOP/kernel/msm-4.4 O=${ANDROID_PRODUCT_OUT}/obj/KERNEL_OBJ/ ARCH=${TARGET_ARCH} CROSS_COMPILE=${TOOLCHAIN} -j${NCPUS} KCFLAGS=${KERNEL_C_FLAGS} menuconfig
	# cp ${ANDROID_PRODUCT_OUT}/obj/KERNEL_OBJ/.config ${SCRIPT_PATH}/kernel/arch/arm64/configs/msm8909-1gb_defconfig
}

kernel_make() {
	# cd $ANDROID_BUILD_TOP/kernel/msm-4.4
	echo "make -C $ANDROID_BUILD_TOP/kernel/msm-4.4 O=${ANDROID_PRODUCT_OUT}/obj/KERNEL_OBJ/ ARCH=${TARGET_ARCH} CROSS_COMPILE=${TOOLCHAIN} -j${NCPUS} KCFLAGS=${KERNEL_C_FLAGS}"
	make -C $ANDROID_BUILD_TOP/kernel/msm-4.4 O=${ANDROID_PRODUCT_OUT}/obj/KERNEL_OBJ/ ARCH=${TARGET_ARCH} CROSS_COMPILE=${TOOLCHAIN} -j${NCPUS} KCFLAGS=${KERNEL_C_FLAGS}
}

kernel_distclean() {
	make -C $ANDROID_BUILD_TOP/kernel/msm-4.4 O=${ANDROID_PRODUCT_OUT}/obj/KERNEL_OBJ/ ARCH=${TARGET_ARCH} CROSS_COMPILE=${TOOLCHAIN} mrproper
}

make_bootimage() {
	local PWD=`pwd`
	cd ${ANDROID_BUILD_TOP}
	make bootimage -j${NCPUS}
	cd ${PWD}
}

make_all() {
	local PWD=`pwd`
	cd ${ANDROID_BUILD_TOP}
	make -j${NCPUS}
	cd ${PWD}
}


function gen_bootimg() {
	./out/host/linux-x86/bin/boot_signer /boot out/target/product/msm8909/boot.img build/target/product/security/verity.pk8 build/target/product/security/verity.x509.pem out/target/product/msm8909/boot.img
}


if [[ $1 == "menuconfig" ]]; then
	kernel_menuconfig
elif [[ $1 == "kernel" ]]; then
	kernel_make
elif [[ $1 == "clean" ]]; then
	kernel_distclean
fi




