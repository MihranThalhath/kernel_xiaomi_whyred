DEFCONFIG=noname_defconfig
OBJ_DIR=`pwd`/.out
ANYKERNEL_DIR=/home/mihran/anykernel
TOOLCHAIN=/home/mihran/aarch64-linux-android-4.9/bin/aarch64-linux-android-
CLANG_PATH=/home/mihran/linux-x86/clang-r328903/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
ZIP_NAME="NoName-r1.7"
DATE=$(date +"%m-%d-%y")
export KBUILD_BUILD_USER="mihran"
export KBUILD_BUILD_HOST="northkorea"
export KBUILD_COMPILER_STRING=$(/home/mihran/linux-x86/clang-r328903/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
MAKE_OPTS="ARCH=arm64 O=$OBJ_DIR CC=${CLANG_PATH} CLANG_TRIPLE=${CLANG_TRIPLE} CROSS_COMPILE=${TOOLCHAIN}"
if [ ! -d ${OBJ_DIR} ]; then
    mkdir ${OBJ_DIR}
fi

make O=${OBJ_DIR} clean
make O=${OBJ_DIR} mrproper
make ARCH=arm64 O=$OBJ_DIR CROSS_COMPILE=${TOOLCHAIN} $DEFCONFIG
make -j4 ${MAKE_OPTS}

rm -f ${ANYKERNEL_DIR}/Image.gz*
rm -f ${ANYKERNEL_DIR}/zImage*
rm -f ${ANYKERNEL_DIR}/dtb*
cp $OBJ_DIR/arch/arm64/boot/Image.gz-dtb ${ANYKERNEL_DIR}/zImage-dtb
rm -rf ${ANYKERNEL_DIR}/modules/system/vendor/lib/modules
mkdir -p ${ANYKERNEL_DIR}/modules/system/vendor/lib/modules
#cp $OBJ_DIR/drivers/staging/qcacld-3.0/wlan.ko ${ANYKERNEL_DIR}/modules/system/vendor/lib/modules/qca_cld3_wlan.ko
#cp $OBJ_DIR/fs/exfat/exfat.ko ${ANYKERNEL_DIR}/modules/system/vendor/lib/modules/exfat.ko
cd ${ANYKERNEL_DIR}
rm *.zip
zip -r9 ${ZIP_NAME}.zip * -x README ${ZIP_NAME}.zip
