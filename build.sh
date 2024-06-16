#!/bin/bash
 
echo "NDK_PATH is $NDK_PATH"
TOOLCHAIN=clang
ANDROID_VERSION=14

cd libjpeg-turbo

mkdir build
cd build

mkdir armeabi-v7a
cd armeabi-v7a

echo "Build armeabi-v7a arch..."

cmake -G"Unix Makefiles" \
  -DANDROID_ABI=armeabi-v7a \
  -DCMAKE_INSTALL_PREFIX=../../../out/armeabi-v7a \
  -DENABLE_STATIC=TRUE \
  -DANDROID_ARM_MODE=arm \
  -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
  -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
  -DCMAKE_ASM_FLAGS="--target=arm-linux-androideabi${ANDROID_VERSION}" \
  -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
  ../../
make
make install
# make clean

cd ../
mkdir arm64-v8a
cd arm64-v8a

echo "Build arm64-v8a arch..."

cmake -G"Unix Makefiles" \
  -DANDROID_ABI=arm64-v8a \
  -DCMAKE_INSTALL_PREFIX=../../../out/arm64-v8a \
  -DENABLE_STATIC=TRUE \
  -DANDROID_ARM_MODE=arm \
  -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
  -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
  -DCMAKE_ASM_FLAGS="--target=aarch64-linux-android${ANDROID_VERSION}" \
  -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
  ../../
  
make
make install

cd ../
mkdir x86
cd x86

echo "Build x86 arch..."

cmake -G"Unix Makefiles" \
  -DANDROID_ABI=x86 \
  -DCMAKE_INSTALL_PREFIX=../../../out/x86 \
  -DENABLE_STATIC=TRUE \
  -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
  -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
  -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
  ../../

make
make install
#make clean

cd ../
mkdir x86_64
cd x86_64

echo "Build x86_64 arch..."

cmake -G"Unix Makefiles" \
  -DANDROID_ABI=x86_64 \
  -DCMAKE_INSTALL_PREFIX=../../../out/x86_64 \
  -DENABLE_STATIC=TRUE \
  -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
  -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
  -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
  ../../

make
make install

echo "Build complete."
