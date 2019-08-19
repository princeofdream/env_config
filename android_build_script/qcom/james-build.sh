#!/bin/bash -
#===============================================================================
#
#          FILE: james-build.sh
#
#         USAGE: ./james-build.sh
#
#   DESCRIPTION: android build for qualcomm
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 07/16/2019 04:52:32 PM
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error

set -o errexit
set -o pipefail

SCRIPT_PATH=$(dirname $(readlink -f "$0"))
TOP_DIR=${SCRIPT_PATH}
ANDROID_DIR=${SCRIPT_PATH}

# Set defaults
TARGET=e28
GET_TARGET=""
TARGET_SETUP_FILE="${TOP_DIR}/android.target"

FLASH_TYPE="none"
VARIANT="eng"
JOBS=12
CCACHE="true"
BUILD_TYPE="msm8996"
CHIPSET=msm8996
# GET_BY_DATE=`date +%Y%m%d`
GET_BY_DATE=""

CHIPCODE_DIR=${TOP_DIR}/vendor/chipcode/xmart
ROM_BUILD_TIME="$(date +%Y%m%d%H%M)"

COPY_PATH_IMAGES_DEST=${ANDROID_DIR}/${TARGET}_${VARIANT}_${ROM_BUILD_TIME}
COPY_PATH_IMAGES_BOOT=${CHIPCODE_DIR}/boot_images/QcomPkg/Msm8996Pkg/Bin64/
COPY_PATH_IMAGES_TRUSTZONE=${CHIPCODE_DIR}/trustzone_images/build/ms/bin/IADAANAA/
COPY_PATH_IMAGES_RPMPROC=${CHIPCODE_DIR}/rpm_proc/build/ms/bin/AAAAANAAR/
COPY_PATH_IMAGES_COMMON=${CHIPCODE_DIR}/common/build/
COPY_PATH_IMAGES_CONFIG=${CHIPCODE_DIR}/common/config/
COPY_PATH_IMAGES_EMMC=${CHIPCODE_DIR}/common/build/emmc/
COPY_PATH_IMAGES_UFS=${CHIPCODE_DIR}/common/build/ufs/
COPY_PATH_IMAGES_ADSPROC=${CHIPCODE_DIR}/adsp_proc/build/dynamic_signed/
COPY_PATH_IMAGES_RESOURCES=${CHIPCODE_DIR}/common/sectools/resources/build/fileversion2/

NEED_LUNCH_ANDROID_ENV="true"

FIRMWARE_VERSION=""

logd ()
{
	if [[ $DEBUG == 0 ]]; then
		return 0
	fi
	CURRENT_TIME=`date +%H:%M:%S`
	if [[ "${LOG_FILE}x" != "x" ]]; then
		echo -e "[0;31;1m[ ${CURRENT_TIME} ]\t[0m[0;32;1m$@ [0m" | tee ${LOG_FILE}.log
	else
		echo -e "[0;31;1m[ ${CURRENT_TIME} ]\t[0m[0;32;1m$@ [0m"
	fi
	return 0
}	# ----------  end of function logd  ----------

loge ()
{
	CURRENT_TIME=`date +%H:%M:%S`
	if [[ "${LOG_FILE}x" != "x" ]]; then
		echo -e "[0;31;1m[ ${CURRENT_TIME} ]\t[0m[0;32;1m$@ [0m" |tee ${LOG_FILE}.log
	else
		echo -e "[0;31;1m[ ${CURRENT_TIME} ]\t[0m[0;32;1m$@ [0m"
	fi
	return 0
}	# ----------  end of function loge  ----------

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
        Specify image to be build/re-build (android/boot/bootimg/sysimg/usrimg/lk/vendor/vbmeta)
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
    -t, --target
		Build target, for ex, e28/d21 (Default: $TARGET)
    -f, --flash
		Pack flash type, for ex, emmc/ufs (Default: $FLASH_TYPE)
    -g, --get
        Get manifest.xml by date

USAGE
}

clean_build() {
    loge "\nINFO: Removing entire out dir. . .\n"
    make clobber
}

build_android() {
    loge "\nINFO: Build Android tree for $TARGET\n"
    make $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_lk ()
{
    loge "\nINFO: Build lk\n"
	make aboot $@
	ret=$?
	loge "Usage: fastboot flash aboot emmc_appsboot.mbn"
	return $ret
}	# ----------  end of function build_lk  ----------

build_bootimg() {
    loge "\nINFO: Build bootimage for $TARGET\n"
	cd $ANDROID_DIR
    make bootimage $@ | tee $LOG_FILE.log
	ret=$?
	loge "Usage: fastboot flash boot_a boot.img"
	return $ret
}

build_sysimg() {
    loge "\nINFO: Build systemimage for $TARGET\n"
    make systemimage $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_vbmeta() {
	loge "\nINFO: Build vbmetaimage for $TARGET\n"
	make vbmetaimage $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_vendor() {
    loge "\nINFO: Build vendorimage for $TARGET\n"
    make vendorimage $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_usrimg() {
    loge "\nINFO: Build userdataimage for $TARGET\n"
    make userdataimage $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_module() {
    loge "\nINFO: Build $MODULE for $TARGET\n"
    make $MODULE $@ | tee $LOG_FILE.log
	ret=$?
	return $ret
}

build_project() {
    loge "\nINFO: Build $PROJECT for $TARGET\n"
    mmm $PROJECT | tee $LOG_FILE.log
	ret=$?
	return $ret
}

update_api() {
    loge "\nINFO: Updating APIs\n"
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
    loge "\nINFO: Setting CCACHE with 10 GB\n"
    setup_ccache
    delete_ccache
    echo "${ANDROID_DIR}/prebuilts/misc/linux-x86/ccache/ccache -M 10G"
    ${ANDROID_DIR}/prebuilts/misc/linux-x86/ccache/ccache -M 10G
}



copy_images_to_out ()
{
	STORAGE_DIR="$FLASH_TYPE"
	COPY_PATH_IMAGES_DEST=${ANDROID_DIR}/${TARGET}_${VARIANT}_${ROM_BUILD_TIME}
	COPY_PATH_IMAGES_OUT=${ANDROID_DIR}/out/target/product/$TARGET/

	loge "copying for $TARGET $FLASH_TYPE ... to $COPY_PATH_IMAGES_DEST"
	if [[ ! -d $COPY_PATH_IMAGES_OUT ]]; then
		loge "Can not find target $TARGET out directory $COPY_PATH_IMAGES_OUT"
		return -1
	fi

	if [[ ! -d "$COPY_PATH_IMAGES_DEST" ]]; then
		mkdir -p $COPY_PATH_IMAGES_DEST
	fi
	cp   $COPY_PATH_IMAGES_BOOT/xbl.elf                                       $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/prog_${STORAGE_DIR}_firehose_8996_ddr.elf     $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/JtagProgrammer.elf                            $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/pmic.elf                                      $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/DeviceProgrammerDDR.elf                       $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_BOOT/pmic.elf                                      $COPY_PATH_IMAGES_DEST/

	cp   $COPY_PATH_IMAGES_TRUSTZONE/tz.mbn                                   $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_TRUSTZONE/hyp.mbn                                  $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_TRUSTZONE/km4.mbn                                  $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_TRUSTZONE/cmnlib.mbn                               $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_TRUSTZONE/cmnlib64.mbn                             $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_TRUSTZONE/lksecapp.mbn                             $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_TRUSTZONE/devcfg_auto.mbn                          $COPY_PATH_IMAGES_DEST/

	cp   $COPY_PATH_IMAGES_RPMPROC/rpm.mbn                                    $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_ADSPROC/adspso.bin                                 $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_RESOURCES/sec.dat                                  $COPY_PATH_IMAGES_DEST/

	cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/bin/modemlite/NON-HLOS.bin   $COPY_PATH_IMAGES_DEST/
	cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/bin/BTFM.bin                 $COPY_PATH_IMAGES_DEST/

	if [[ "ufs" == "$2" ]];then
		cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/gpt_backup*.bin                   $COPY_PATH_IMAGES_DEST/
		cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/gpt_main*.bin                     $COPY_PATH_IMAGES_DEST/
		cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/rawprogram*.xml                   $COPY_PATH_IMAGES_DEST/
		cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/patch*.xml                        $COPY_PATH_IMAGES_DEST/
		cp   $COPY_PATH_IMAGES_CONFIG/${STORAGE_DIR}/provision/provision_toshiba.xml   $COPY_PATH_IMAGES_DEST/
	else
		cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/gpt_backup0.bin   $COPY_PATH_IMAGES_DEST/
		cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/gpt_main0.bin     $COPY_PATH_IMAGES_DEST/
		cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/rawprogram0.xml   $COPY_PATH_IMAGES_DEST/
		cp   $COPY_PATH_IMAGES_COMMON/${STORAGE_DIR}/patch0.xml        $COPY_PATH_IMAGES_DEST/
	fi

	cp $COPY_PATH_IMAGES_OUT/userdata_emmc.img      $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/vbmeta.img             $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/vendor.img             $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/vmap_emmc.img          $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/boot.img               $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/dtbo.img               $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/emmc_appsboot.mbn      $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/mdtp.img               $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/persist.img            $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/prebuilt_dtbo.img      $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/ramdisk.img            $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/ramdisk-recovery.img   $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/splash_emmc.img        $COPY_PATH_IMAGES_DEST/
	cp $COPY_PATH_IMAGES_OUT/system.img             $COPY_PATH_IMAGES_DEST/

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
	zip -vj  ./LINUX/android/out/target/product/$TARGET/S820A_$2_$1_$3_$4.zip ./LINUX/android/out/target/product/$TARGET/*.elf ./LINUX/android/out/target/product/msm8996/*.mbn ./LINUX/android/out/target/product/msm8996/*.bin ./LINUX/android/out/target/product/msm8996/*.img ./LINUX/android/out/target/product/msm8996/*.xml ./LINUX/android/out/target/product/msm8996/sec.dat
	ret=$?
	return $ret
}	# ----------  end of function build_zip_files  ----------

checkout_git_by_xml ()
{
	HTTP_XML_BUFFER=`curl -i POST http://10.192.39.176:8080/job/Xmart_Edward_Rom_tag/ws/20190510/e28/%E5%BE%90%E4%BF%8A/315/e28_et2/manifest.xml --user lijin:123qweASD`
	echo "$HTTP_XML_BUFFER"

	ret=$?
	return $ret
}


update_env ()
{
	COPY_PATH_IMAGES_DEST=${ANDROID_DIR}/${TARGET}_${VARIANT}_${ROM_BUILD_TIME}
}	# ----------  end of function update_env  ----------

main_func ()
{
	# Mandatory argument
	# if [ $# -eq 0 ]; then
	#     loge "\nERROR: Missing mandatory argument: TARGET_PRODUCT\n"
	#     usage
	#     exit 1
	# fi

	# if [ $# -gt 1 ]; then
	#     loge "\nERROR: Extra inputs. Need TARGET_PRODUCT only\n"
	#     usage
	#     exit 1
	# fi
	# # TARGET="$1"; shift

	if [[ "${GET_TARGET}x" == "x" && -f ${TARGET_SETUP_FILE} ]]; then
		loge "Try to get TARGET from file ${TARGET_SETUP_FILE}"
		i0=0;
		while read line ;
		do
			loge "read [${i0}]: ${line}"
			if [[ "${line}x" != "x" ]]; then
				TARGET=${line}
				break;
			fi
			i0=$((i0+1))
		done < ${TARGET_SETUP_FILE}
	fi

	loge ""
	loge "## ================================================ ##"
	loge "Build target ${TARGET}"
	loge "## ================================================ ##"
	loge ""

	update_env

	cd $ANDROID_DIR

	if [[ ! $FLASH_TYPE == "none" ]]; then
		if [[ ! $FLASH_TYPE == "ufs" ]]; then
			FLASH_TYPE="emmc"
		fi
		copy_images_to_out
		exit 0
	fi

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

	if [[ ! "$GET_BY_DATE" == "" ]]; then
		checkout_git_by_xml
		return 0;
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
	loge "\nERROR: No arguments Found!\n"
	usage
	exit 1
fi

# Setup getopt.
long_opts="clean_build,debug,help,image:,jobs:,kernel_defconf:,log_file:,module:,"
long_opts+="project:,setup_ccache:,update-api,build_variant:,"
long_opts+="boot,pack,zip,all,target:,get:,flash:"
getopt_cmd=$(getopt -o cdhi:j:k:l:m:p:s:uv:brzat:g:f: --long "$long_opts" \
            -n $(basename $0) -- "$@") || \
            { echo -e "\nERROR: Getopt failed. Extra args\n"; usage; exit 1;}

eval set -- "$getopt_cmd"

loge "args: $@"
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
		-t|--target) GET_TARGET="$2" ;;
        -f|--flash) FLASH_TYPE="$2"; shift;;
		-g|--get) GET_BY_DATE="$2" ;;
        --) shift; break;;
    esac
	shift
done

loge "Start Build: $(date +%Y/%m/%d-%H:%M:%S)"

main_func $@

if [[ $? == 0 ]]; then
	loge "Build Success: $(date +%Y/%m/%d-%H:%M:%S)"
else
	loge "Build Fail: $(date +%Y/%m/%d-%H:%M:%S)"
fi

