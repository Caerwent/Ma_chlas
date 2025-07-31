#!/bin/sh

brew list coreutils || brew install coreutils

if [ -z "${QT_DIR}" ]; then
  echo "No QT_DIR defined, used default value"
  export QT_DIR=$(realpath ../../Tools/6.9.1/macos)
fi
echo "QT_DIR: $QT_DIR"
export Qt6_DIR=$QT_DIR

if [ -z "${CURRENT_VERSION}" ]; then
  echo "No CURRENT_VERSION defined, used default value"
  export CURRENT_VERSION=1.0.0
fi
echo "CURRENT_VERSION: $CURRENT_VERSION"


if [ $(getconf LONG_BIT) -eq 64 ] 
then 
  export ARCH_NAME=x86_64
else
  export ARCH_NAME=i386
fi
  
export ROOT_PATH=$(realpath .)
export PROJECT_PATH=$(realpath ./atalierou)


export BUILD_PATH=./build-Atalierou-macos_$ARCH_NAME-Release
rm -rf $BUILD_PATH
mkdir -p $BUILD_PATH
export BUILD_PATH=$(realpath $BUILD_PATH)

export DISTRIB_PATH=./distrib/macos_$ARCH_NAME
rm -rf $DISTRIB_PATH
mkdir -p $DISTRIB_PATH
export DISTRIB_PATH=$(realpath ./distrib/macos_$ARCH_NAME)

cd $PROJECT_PATH

echo "============================================="
echo "            launch cmake"
echo "============================================="
$QT_DIR/../../Tools/CMake/CMake.app/Contents/bin/cmake -S . -B $BUILD_PATH
$QT_DIR/../../Tools/CMake/CMake.app/Contents/bin/cmake --build $BUILD_PATH


echo "============================================="
echo "            launch macdeployqt"
echo "============================================="
cd $BUILD_PATH
$QT_DIR/bin/macdeployqt6 Atalierou.app -qmldir=$PROJECT_PATH/qml -dmg
cd $ROOT_PATH
echo "move file $BUILD_PATH/Atalierou.dmg Atalierou_${CURRENT_VERSION}_${ARCH_NAME}.dmg"
mv $BUILD_PATH/Atalierou.dmg Atalierou_${CURRENT_VERSION}_${ARCH_NAME}.dmg

