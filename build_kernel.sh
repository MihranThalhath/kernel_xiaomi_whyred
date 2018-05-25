if [ "$1" = "clang" ]; then
    echo "Building kernel with clang toolchain"
else
    echo "Building kernel with GCC toolchain"
fi
DEFCONFIG=whyred-perf_defconfig
OBJ_DIR=`pwd`/.obj
ANYKERNEL_DIR=${HOME}/ak
TOOLCHAIN=${HOME}/tc/aarch64-linux-android-4.9/bin/aarch64-linux-androidkernel-
CLANG_PATH=${HOME}/tc/clang-stable/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
WEB_SERVER_ROOT=/var/www/html
DATE=$(date +"%m-%d-%y")

if [ "$1" = "clang" ]; then
    MAKE_OPTS="ARCH=arm64 O=$OBJ_DIR CC=${CLANG_PATH} CLANG_TRIPLE=${CLANG_TRIPLE} CROSS_COMPILE=${TOOLCHAIN}"
else
    MAKE_OPTS="ARCH=arm64 O=$OBJ_DIR CROSS_COMPILE=${TOOLCHAIN}"
fi

if [ ! -d ${OBJ_DIR} ]; then
    mkdir ${OBJ_DIR}
fi

make ARCH=arm64 O=$OBJ_DIR CROSS_COMPILE=${TOOLCHAIN} $DEFCONFIG
make -j$(grep -c ^processor /proc/cpuinfo) ${MAKE_OPTS}

rm -f ${ANYKERNEL_DIR}/Image.gz*
rm -f ${ANYKERNEL_DIR}/zImage*
rm -f ${ANYKERNEL_DIR}/dtb*
cp $OBJ_DIR/arch/arm64/boot/Image.gz-dtb ${ANYKERNEL_DIR}/zImage-dtb
cp $OBJ_DIR/drivers/staging/qcacld-3.0/wlan.ko ${ANYKERNEL_DIR}/modules/qca_cld3_wlan.ko
cd ${ANYKERNEL_DIR}
rm *.zip
zip -r9 ZeurionX-$DATE.zip * -x README ZeurionX-$DATE.zip
cp Z* ${WEB_SERVER_ROOT}
