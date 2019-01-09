#!/bin/bash
#
# Copyright (c) 2012, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

set -o errexit
set -o pipefail

SCRIPT_PATH=$(dirname $(readlink -f "$0"))
TOP_DIR=${SCRIPT_PATH}
ANDROID_DIR=${SCRIPT_PATH}

# Set defaults
TARGET=e28
VARIANT="eng"
JOBS=8
CCACHE="true"
BUILD_TYPE="msm8996"
CHIPSET=msm8996

CHIPCODE_DIR=${TOP_DIR}/vendor/chipcode/$TARGET
ROM_BUILD_TIME="$(date +%Y%m%d%H%M)"

COPY_PATH_IMAGES_DEST=${ANDROID_DIR}/out/target/product/msm8996/
COPY_PATH_IMAGES_BOOT=${CHIPCODE_DIR}/boot_images/QcomPkg/Msm8996Pkg/Bin64/
COPY_PATH_IMAGES_TRUSTZONE=${CHIPCODE_DIR}/trustzone_images/build/ms/bin/IADAANAA/
COPY_PATH_IMAGES_RPMPROC=${CHIPCODE_DIR}/rpm_proc/build/ms/bin/AAAAANAAR/
COPY_PATH_IMAGES_EMMC=${CHIPCODE_DIR}/common/build/emmc/
COPY_PATH_IMAGES_ADSPROC=${CHIPCODE_DIR}/adsp_proc/build/dynamic_signed/
COPY_PATH_IMAGES_RESOURCES=${CHIPCODE_DIR}/common/sectools/resources/build/fileversion2/

NEED_LUNCH_ANDROID_ENV="true"

FIRMWARE_VERSION=""

usage() {
cat <<USAGE

Usage:
    bash $0 <TARGET_PRODUCT> [OPTIONS]

Description:
    Builds Android tree for given TARGET_PRODUCT

OPTIONS:
    -c, --clean_build
        Clean build - build from scratch by removing entire out dir
    -d, --debug
        Enable debugging - captures all commands while doing the build
    -h, --help
        Display this help message
    -i, --image
        Specify image to be build/re-build (android/boot/bootimg/sysimg/usrimg/lk/vendor)
    -j, --jobs
        Specifies the number of jobs to run simultaneously (Default: 8)
    -k, --kernel_defconf
        Specify defconf file to be used for compiling Kernel
    -l, --log_file
        Log file to store build logs (Default: <TARGET_PRODUCT>.log)
    -m, --module
        Module to be build
    -p, --project
        Project to be build
    -s, --setup_ccache
        Set CCACHE for faster incremental builds (true/false - Default: true)
    -u, --update-api
        Update APIs
    -v, --build_variant
        Build variant (Default: $VARIANT)
    -n, --boot
        Build boot Image
    -r, --pack
        Pack Image
    -z, --zip
        Copy and zip files
    -a, --all
        Build All and pack

USAGE
}

clean_build() {
    echo -e "\nINFO: Removing entire out dir. . .\n"
    make clobber
}

build_android() {
    echo -e "\nINFO: Build Android tree for $TARGET\n"
    make $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_lk ()
{
    echo -e "\nINFO: Build lk\n"
	make aboot $@
	ret=$?
	echo "Usage: fastboot flash aboot emmc_appsboot.mbn"
	return $ret
}	# ----------  end of function build_lk  ----------

build_bootimg() {
    echo -e "\nINFO: Build bootimage for $TARGET\n"
	cd $ANDROID_DIR
    make bootimage $@ | tee $LOG_FILE.log
	ret=$?
	echo "Usage: fastboot flash boot_a boot.img"
	return $ret
}

build_sysimg() {
    echo -e "\nINFO: Build systemimage for $TARGET\n"
    make systemimage $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_vendor() {
    echo -e "\nINFO: Build vendorimage for $TARGET\n"
    make vendorimage $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_usrimg() {
    echo -e "\nINFO: Build userdataimage for $TARGET\n"
    make userdataimage $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_module() {
    echo -e "\nINFO: Build $MODULE for $TARGET\n"
    make $MODULE $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_project() {
    echo -e "\nINFO: Build $PROJECT for $TARGET\n"
    mmm $PROJECT | tee $LOG_FILE.log
	ret=$?
	return $ret
}

update_api() {
    echo -e "\nINFO: Updating APIs\n"
    make update-api | tee $LOG_FILE.log
}

setup_ccache() {
    echo "export CCACHE_DIR=${ANDROID_DIR}/.ccache && export USE_CCACHE=1"
    export CCACHE_DIR=${ANDROID_DIR}/.ccache
    export USE_CCACHE=1
}

delete_ccache() {
	echo "prebuilts/misc/linux-x86/ccache/ccache -C"
    echo "rm -rf $CCACHE_DIR"
    prebuilts/misc/linux-x86/ccache/ccache -C
    rm -rf $CCACHE_DIR
}

create_ccache() {
    echo -e "\nINFO: Setting CCACHE with 10 GB\n"
    setup_ccache
    delete_ccache
    echo "${ANDROID_DIR}/prebuilts/misc/linux-x86/ccache/ccache -M 10G"
    ${ANDROID_DIR}/prebuilts/misc/linux-x86/ccache/ccache -M 10G
}



copy_images_to_out ()
{
	cp   $COPY_PATH_IMAGES_BOOT/xbl.elf                           $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/prog_emmc_firehose_8996_ddr.elf   $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/JtagProgrammer.elf                $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/pmic.elf                          $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/DeviceProgrammerDDR.elf           $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/pmic.elf                          $COPY_PATH_IMAGES_DEST/

	#cp $COPY_PATH_IMAGES_DEST/emmc_appsboot.mbn $COPY_PATH_IMAGES_DEST/

	cp    $COPY_PATH_IMAGES_TRUSTZONE/tz.mbn                  $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_TRUSTZONE/hyp.mbn                 $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_TRUSTZONE/keymaster.mbn           $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_TRUSTZONE/cmnlib.mbn              $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_TRUSTZONE/cmnlib64.mbn            $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_TRUSTZONE/lksecapp.mbn            $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_TRUSTZONE/devcfg_auto.mbn         $COPY_PATH_IMAGES_DEST/

	cp    $COPY_PATH_IMAGES_RESOURCES/sec.dat                 $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_EMMC/gpt_backup0.bin              $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_EMMC/gpt_main0.bin                $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_EMMC/rawprogram0.xml              $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_EMMC/patch0.xml                   $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_EMMC/bin/BTFM.bin                 $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_EMMC/bin/asic/NON-HLOS.bin        $COPY_PATH_IMAGES_DEST/ASIC-NON-HLOS.bin
	#cp   $COPY_PATH_IMAGES_EMMC/bin/modemlite/NON-HLOS.bin   $COPY_PATH_IMAGES_DEST/

	cp    $COPY_PATH_IMAGES_RPMPROC/rpm.mbn                   $COPY_PATH_IMAGES_DEST/
	cp    $COPY_PATH_IMAGES_ADSPROC/adspso.bin                $COPY_PATH_IMAGES_DEST/
}	# ----------  end of function copy_images_to_out  ----------

build_pack ()
{
	cd ${CHIPCODE_DIR}/boot_images/QcomPkg/Msm8996Pkg/
	./b64LA.sh
	ret=$?
	if [[ $ret != 0 ]]; then
		return $ret
	fi
	cd ${CHIPCODE_DIR}/trustzone_images/build/ms/
	source setenv.sh
	./build.sh CHIPSET=$CHIPSET devcfg_auto
	ret=$?
	if [[ $ret != 0 ]]; then
		return $ret
	fi

	cd ${CHIPCODE_DIR}/common/build/
	./build.py
	ret=$?
	return $ret
}	# ----------  end of function build_pack  ----------


build_zip_files ()
{
	zip -vj  ./LINUX/android/out/target/product/msm8996/S820A_$2_$1_$3_$4.zip ./LINUX/android/out/target/product/msm8996/*.elf ./LINUX/android/out/target/product/msm8996/*.mbn ./LINUX/android/out/target/product/msm8996/*.bin ./LINUX/android/out/target/product/msm8996/*.img ./LINUX/android/out/target/product/msm8996/*.xml ./LINUX/android/out/target/product/msm8996/sec.dat
	ret=$?
	return $ret
}	# ----------  end of function build_zip_files  ----------

main_func ()
{
	# Mandatory argument
	# if [ $# -eq 0 ]; then
	#     echo -e "\nERROR: Missing mandatory argument: TARGET_PRODUCT\n"
	#     usage
	#     exit 1
	# fi

	# if [ $# -gt 1 ]; then
	#     echo -e "\nERROR: Extra inputs. Need TARGET_PRODUCT only\n"
	#     usage
	#     exit 1
	# fi
	# # TARGET="$1"; shift

	cd $ANDROID_DIR

	## force delete dtb files to make build update
	if [[ -d ${ANDROID_DIR}/out/target/product/$TARGET_PRODUCT/obj/KERNEL_OBJ/arch/arm64/boot/ ]]; then
		rm -rf ${ANDROID_DIR}/out/target/product/$TARGET_PRODUCT/obj/KERNEL_OBJ/arch/arm64/boot/
	fi

	if [ -z $LOG_FILE ]; then
		LOG_FILE=$TARGET
	fi

	CMD="-j $JOBS"
	if [ "$DEBUG" = "true" ]; then
		CMD+=" showcommands"
	fi
	if [ -n "$DEFCONFIG" ]; then
		CMD+=" KERNEL_DEFCONFIG=$DEFCONFIG"
	fi

	if [ "$CCACHE" = "true" ]; then
		setup_ccache
	fi

	if [[ "$NEED_LUNCH_ANDROID_ENV" == "true" ]]; then
		if [[ $TARGET_BUILD_VARIANT == $VARIANT && $TARGET_PRODUCT == $TARGET ]]; then
			echo "TARGET_PRODUCT=$TARGET_PRODUCT TARGET_BUILD_VARIANT=$TARGET_BUILD_VARIANT does not change!"
		else
			echo "TARGET_BUILD_VARIANT=$TARGET_BUILD_VARIANT changed!"
			source build/envsetup.sh
			lunch $TARGET-$VARIANT
		fi
	fi

	if [ "$CLEAN_BUILD" = "true" ]; then
		clean_build
		if [ "$CCACHE" = "true" ]; then
			create_ccache
		fi
	fi

	ret=0
	if [[ $BUILD_TYPE == "all" ]]; then
		build_android "$CMD"
		ret=$?
		if [[ $ret != 0 ]]; then
			return $ret
		fi
		build_pack
		ret=$?
	elif [[ $BUILD_TYPE == "boot" ]]; then
		build_bootimg "$CMD"
		ret=$?
	elif [[ $BUILD_TYPE == "pack" ]]; then
		build_pack
		ret=$?
	elif [ "$UPDATE_API" = "true" ]; then
		update_api
		ret=$?
	elif [ -n "$MODULE" ]; then
		build_module "$CMD"
		ret=$?
	elif [ -n "$PROJECT" ]; then
		build_project
		ret=$?
	elif [ -n "$IMAGE" ]; then
		build_$IMAGE "$CMD"
		ret=$?
	else
		echo "Build nothing!"
	fi

	CHECK_JACK=true
	type jack-admin >/dev/null 2>&1 || CHECK_JACK=false
	if [[ $CHECK_JACK == "true" ]]; then
		jack-admin stop-server
	fi

	return $ret
}	# ----------  end of function main_func  ----------


if [ $# -eq 0 ]; then
	echo -e "\nERROR: No arguments Found!\n"
	usage
	exit 1
fi

# Setup getopt.
long_opts="clean_build,debug,help,image:,jobs:,kernel_defconf:,log_file:,module:,"
long_opts+="project:,setup_ccache:,update-api,build_variant:,"
long_opts+="boot,pack,zip,all,target:"
getopt_cmd=$(getopt -o cdhi:j:k:l:m:p:s:uv:brzat: --long "$long_opts" \
            -n $(basename $0) -- "$@") || \
            { echo -e "\nERROR: Getopt failed. Extra args\n"; usage; exit 1;}

eval set -- "$getopt_cmd"

echo "args: $@"
while true; do
    case "$1" in
        -c|--clean_build) CLEAN_BUILD="true";;
        -d|--debug) DEBUG="true";;
        -h|--help) usage; exit 0;;
        -i|--image) IMAGE="$2"; shift;;
        -j|--jobs) JOBS="$2"; shift;;
        -k|--kernel_defconf) DEFCONFIG="$2"; shift;;
        -l|--log_file) LOG_FILE="$2"; shift;;
        -m|--module) MODULE="$2"; shift;;
        -p|--project) PROJECT="$2"; shift;;
        -u|--update-api) UPDATE_API="true";;
        -s|--setup_ccache) CCACHE="$2"; shift;;
        -v|--build_variant) VARIANT="$2"; shift;;
		-b|--boot) BUILD_TYPE="boot" ;;
		-r|--pack) BUILD_TYPE="pack" ; NEED_LUNCH_ANDROID_ENV="false" ;;
		-z|--zip) BUILD_TYPE="zip" ;;
		-a|--all) BUILD_TYPE="all" ;;
		-t|--target) TARGET="$2" ;;
        --) shift; break;;
    esac
	shift
done

echo "--- Start Build: $(date +%Y/%m/%d-%H:%M:%S) ---"

main_func $@

if [[ $? == 0 ]]; then
	echo "--- Build Success: $(date +%Y/%m/%d-%H:%M:%S) ---"
else
	echo "--- Build Fail: $(date +%Y/%m/%d-%H:%M:%S) ---"
fi

