#!/bin/sh

brew list realpath || brew install realpath

if [ -z "${QT_DIR}" ]; then
  echo "No QT_DIR defined, used default value"
  export QT_DIR=$(realpath ../Qt/6.2.2/gcc_64)
fi
echo "QT_DIR: $QT_DIR"

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


export BUILD_PATH=./build-Atalierou-linux_$ARCH_NAME-Release
rm -rf $BUILD_PATH
mkdir -p $BUILD_PATH
export BUILD_PATH=$(realpath $BUILD_PATH)

export DISTRIB_PATH=./distrib/macos_$ARCH_NAME
rm -rf $DISTRIB_PATH
mkdir -p $DISTRIB_PATH
export DISTRIB_PATH=$(realpath ./distrib/macos_$ARCH_NAME)

cd $BUILD_PATH


$QT_DIR/bin/qmake -o Makefile $PROJECT_PATH/Atalierou.pro -spec macx-clang CONFIG+=qtquickcompiler

make -f Makefile qmake_all
make -f Makefile -j8


$QT_DIR/bin/macdeployqt Atalierou.app -qmldir=$PROJECT_PATH/qml -dmg
cd $ROOT_PATH
mv $BUILD_PATH/Atalierou.dmg Atalierou_${CURRENT_VERSION}_${ARCH_NAME}.dmg

