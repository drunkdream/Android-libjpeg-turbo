#! /bin/bash

build_libjpeg_turbo(){
    mkdir "out/$1"
    
    SYSROOT=${NDK_PATH}/platforms/android-${ANDROID_VERSION}/arch-$1
    
    if [ $1 = "arm" ]; then
        HOST=arm-linux-androideabi
        TOOLCHAIN=${NDK_PATH}/toolchains/$HOST-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}
        ANDROID_CFLAGS="-march=armv7-a -mfloat-abi=softfp -fprefetch-loop-arrays -mfpu=neon -mthumb -D__ANDROID__ -D__ARM_ARCH_7__  --sysroot=${SYSROOT}"
    elif [ $1 = "arm64" ]; then
        HOST=aarch64-linux-android
        TOOLCHAIN=${NDK_PATH}/toolchains/$HOST-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}
        ANDROID_CFLAGS="--sysroot=${SYSROOT}"
    elif [ $1 = "x86" ]; then
        HOST=i686-linux-android
        TOOLCHAIN=${NDK_PATH}/toolchains/$1-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}
        ANDROID_CFLAGS="--sysroot=${SYSROOT}"
    elif [ $1 = "x86_64" ]; then
        HOST=x86_64-linux-android
        TOOLCHAIN=${NDK_PATH}/toolchains/$1-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}
        ANDROID_CFLAGS="--sysroot=${SYSROOT}"
    fi
    
    export CPP=${TOOLCHAIN}/bin/${HOST}-cpp
    export AR=${TOOLCHAIN}/bin/${HOST}-ar
    export NM=${TOOLCHAIN}/bin/${HOST}-nm
    export CC=${TOOLCHAIN}/bin/${HOST}-gcc
    export LD=${TOOLCHAIN}/bin/${HOST}-ld
    export RANLIB=${TOOLCHAIN}/bin/${HOST}-ranlib
    export OBJDUMP=${TOOLCHAIN}/bin/${HOST}-objdump
    export STRIP=${TOOLCHAIN}/bin/${HOST}-strip
    
    cd "libjpeg-turbo-1.5.3"
    make clean
    sh configure --host=${HOST} \
      CFLAGS="${ANDROID_CFLAGS} -O3 -fPIE" \
      CPPFLAGS="${ANDROID_CFLAGS}" \
      LDFLAGS="${ANDROID_CFLAGS} -pie" --with-simd --with-jpeg8 ${2+"$@"} 
    make
    
    cp .libs/*.a "../out/$1/"
    cp .libs/*.so "../out/$1/"
    cd ../
}

usage(){
    echo "usage: sh build.sh arm/arm64/x86/x86_64/all"
    exit 1
}

NDK_PATH=$NDK_PATH
BUILD_PLATFORM=linux-x86_64
TOOLCHAIN_VERSION=4.9
ANDROID_VERSION=21

if [ -z $NDK_PATH ] || [ ! -d $NDK_PATH ] || [ ! -f "$NDK_PATH/ndk-build" ]; then
    echo "\$NDK_PATH is not correct!"
    exit 1
fi

if [ $# -lt 1 ]; then
    usage
fi

if [ ! -d "out" ]; then
    mkdir "out"
fi

if [ $1 = "arm" ] || [ $1 = "arm64" ] || [ $1 = "x86" ] || [ $1 = "x86_64" ]; then
    build_libjpeg_turbo $1
    echo "build success, output dir is out/$1"
elif [ $1 = "all" ]; then
    build_libjpeg_turbo "arm"
    build_libjpeg_turbo "arm64"
    build_libjpeg_turbo "x86"
    build_libjpeg_turbo "x86_64"
    echo "build success, output dir is out"
else
    usage
fi



