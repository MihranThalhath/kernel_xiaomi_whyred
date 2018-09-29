DEFCONFIG=whyred-perf_defconfig
OBJ_DIR=`pwd`/.out
ANYKERNEL_DIR=/home/mihranz7/anykernel2
TOOLCHAIN=/home/mihranz7/aarch64-linux-android-4.9/bin/aarch64-linux-android-
CLANG_PATH=/home/mihranz7/linux-x86/clang-r328903/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
ZIP_NAME="NoName-Test"
DATE=$(date +"%m-%d-%y")
export KBUILD_BUILD_USER="mihran"
export KBUILD_BUILD_HOST="northkorea"
export KBUILD_COMPILER_STRING=$(/home/mihranz7/linux-x86/clang-r328903/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/ */ /g' -e 's/[[:space:]]*$//')
MAKE_OPTS="ARCH=arm64 O=$OBJ_DIR CC=${CLANG_PATH} CLANG_TRIPLE=${CLANG_TRIPLE} CROSS_COMPILE=${TOOLCHAIN}"
if [ ! -d ${OBJ_DIR} ]; then
    mkdir ${OBJ_DIR}
fi
make ARCH=arm64 O=$OBJ_DIR CROSS_COMPILE=${TOOLCHAIN} $DEFCONFIG
make O=${OBJ_DIR} clean
make O=${OBJ_DIR} mrproper
make ARCH=arm64 O=$OBJ_DIR CROSS_COMPILE=${TOOLCHAIN} $DEFCONFIG
make -j8 ${MAKE_OPTS}

rm -f ${ANYKERNEL_DIR}/Image.gz*
rm -f ${ANYKERNEL_DIR}/zImage*
rm -f ${ANYKERNEL_DIR}/dtb*
cp $OBJ_DIR/arch/arm64/boot/Image.gz-dtb ${ANYKERNEL_DIR}/zImage-dtb
cd ${ANYKERNEL_DIR}
rm *.zip
zip -r9 ${DATE}.zip * -x README ${DATE}.zip
curl --upload-file ${DATE}.zip https://transfer.sh
