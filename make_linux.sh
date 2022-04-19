#!/bin/sh

if [ -z "${QT_DIR}" ]; then
  echo "No QT_DIR defined, used default value"
  export QT_DIR=$(realpath ../Qt/6.2.3/gcc_64)
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
  
export PATH=.:$PATH
export ROOT_PATH=$(realpath .)
export PROJECT_PATH=$(realpath ./atalierou)


export BUILD_PATH=./build-Atalierou-linux_$ARCH_NAME-Release
rm -rf $BUILD_PATH
mkdir -p $BUILD_PATH
export BUILD_PATH=$(realpath $BUILD_PATH)

export DISTRIB_PATH=./distrib/linux_$ARCH_NAME
rm -rf $DISTRIB_PATH
mkdir -p $DISTRIB_PATH
export DISTRIB_PATH=$(realpath ./distrib/linux_$ARCH_NAME)

cd $BUILD_PATH

echo "============================================="
echo "            launch qmake"
echo "============================================="
$QT_DIR/bin/qmake -o Makefile $PROJECT_PATH/Atalierou.pro -spec linux-g++ CONFIG+=qtquickcompiler && make qmake_all

echo "============================================="
echo "            launch make"
echo "============================================="
make -f Makefile -j6


cd $ROOT_PATH

#https://opensourcelibs.com/lib/linuxdeploy-plugin-qt
#https://github.com/linuxdeploy
export QMAKE=$QT_DIR/bin/qmake
export DEBUG=1

export EXTRA_QT_PLUGINS="multimedia;quick;quickcontrols2;qmlworkerscript;quickcontrols2impl;quickparticules;quicktemplates2;shadertools;svg;xcbqpa;LabsFolderListModel;LabsQmlModels;LabsSettings"

echo "============================================="
echo "            launch linuxdeploy"
echo "============================================="
echo "$ROOT_PATH/linuxdeploy-$ARCH_NAME.AppImage --appdir $DISTRIB_PATH -e $BUILD_PATH/Atalierou -d $PROJECT_PATH/Atalierou.desktop -i $PROJECT_PATH/icon.png "
$ROOT_PATH/linuxdeploy-$ARCH_NAME.AppImage --appdir $DISTRIB_PATH -e $BUILD_PATH/Atalierou -d $PROJECT_PATH/Atalierou.desktop -i $PROJECT_PATH/icon.png 

echo "============================================="
echo "            launch linuxdeploy qt"
echo "============================================="
export QML_SOURCES_PATHS=$PROJECT_PATH/qml
echo "$ROOT_PATH/linuxdeploy-plugin-qt-$ARCH_NAME.AppImage --appdir=$DISTRIB_PATH"
$ROOT_PATH/linuxdeploy-plugin-qt-$ARCH_NAME.AppImage --appdir=$DISTRIB_PATH


echo "============================================="
echo "            launch linuxdeploy appimage"
echo "============================================="
export VERSION=$CURRENT_VERSION
echo "CURRENT_VERSION: $CURRENT_VERSION -> VERSION: $VERSION"
export OUTPUT=Atalierou_${VERSION}_${ARCH_NAME}.AppImage
echo "launch $ROOT_PATH/linuxdeploy-plugin-appimage-$ARCH_NAME.AppImage --appdir=$DISTRIB_PATH"
echo "OUTPUT: $OUTPUT"
$ROOT_PATH/linuxdeploy-plugin-appimage-$ARCH_NAME.AppImage --appdir=$DISTRIB_PATH 

