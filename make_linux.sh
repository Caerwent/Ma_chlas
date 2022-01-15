#!/bin/sh

if [ -z "${QT_PATH}" ]; then
  echo "No QT_PATH defined, used default value"
  export QT_PATH=$(realpath ../Qt/6.2.2/gcc_64)
  echo $QT_PATH
fi

if [ -z "${CURRENT_VERSION}" ]; then
  echo "No CURRENT_VERSION defined, used default value"
  export CURRENT_VERSION=1.0.0
  echo $CURRENT_VERSION
fi


export ROOT_PATH=$(realpath .)
export PROJECT_PATH=$(realpath ./atalierou)

export BUILD_PATH=./build-Atalierou-Desktop_Qt_6_2_2_GCC_64bit-Release
rm -rf $BUILD_PATH
mkdir -p $BUILD_PATH
export BUILD_PATH=$(realpath $BUILD_PATH)

export DISTRIB_PATH=./distrib/linux_x86-64
rm -rf $DISTRIB_PATH
mkdir -p $DISTRIB_PATH
export DISTRIB_PATH=$(realpath ./distrib/linux_x86-64)

cd $BUILD_PATH



$QT_PATH/bin/qmake -o Makefile $PROJECT_PATH/Atalierou.pro -spec linux-g++ CONFIG+=qtquickcompiler && make qmake_all

make -f Makefile -j6 install DESTDIR=$DISTRIB_PATH


cd $ROOT_PATH

#https://opensourcelibs.com/lib/linuxdeploy-plugin-qt
#https://github.com/linuxdeploy
export QMAKE=$QT_PATH/bin/qmake
export DEBUG=1

export EXTRA_QT_PLUGINS="quick;quickcontrols2;qmlworkerscript;quickcontrols2impl;quickparticules;quicktemplates2;shadertools;svg;xcbqpa"

echo =========================================================================================
echo ==================================== linuxdeploy ========================================
echo =========================================================================================
echo "$ROOT_PATH/linuxdeploy-x86_64.AppImage --appdir $DISTRIB_PATH -e $BUILD_PATH/Atalierou -d $PROJECT_PATH/Atalierou.desktop -i $PROJECT_PATH/icon512.png "
$ROOT_PATH/linuxdeploy-x86_64.AppImage --appdir $DISTRIB_PATH -e $BUILD_PATH/Atalierou -d $PROJECT_PATH/Atalierou.desktop -i $PROJECT_PATH/icon512.png 

echo =========================================================================================
echo ==================================== linuxdeploy qt =====================================
echo =========================================================================================
export QML_SOURCES_PATHS=$PROJECT_PATH/ui:$PROJECT_PATH/ui/phono:$PROJECT_PATH/dataModels
echo "$ROOT_PATH/linuxdeploy-plugin-qt-x86_64.AppImage --appdir=$DISTRIB_PATH"
$ROOT_PATH/linuxdeploy-plugin-qt-x86_64.AppImage --appdir=$DISTRIB_PATH


echo =========================================================================================
echo ==================================== linuxdeploy appimage ===============================
echo =========================================================================================
export VERSION=$CURRENT_VERSION
echo "$ROOT_PATH/linuxdeploy-plugin-appimage-x86_64.AppImage --appdir=$DISTRIB_PATH"
$ROOT_PATH/linuxdeploy-plugin-appimage-x86_64.AppImage --appdir=$DISTRIB_PATH 

