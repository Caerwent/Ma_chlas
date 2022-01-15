#!/bin/sh

if [[ -z "${QT_PATH}" ]]; then
  echo "No QT_PATH defined, used default value"
  export QT_PATH=$(realpath ../Qt/6.2.2/gcc_64)
  echo $QT_PATH
fi


export ROOT_PATH=$(realpath .)
export BUILD_PATH=$(realpath ./build-Atalierou-Desktop_Qt_6_2_2_GCC_64bit-Release)
export DISTRIB_PATH=$(realpath ./distrib/linux_x86-64)
export PROJECT_PATH=$(realpath ./atalierou)

rm -rf $DISTRIB_PATH
mkdir -p $DISTRIB_PATH
rm -rf $BUILD_PATH
mkdir -p $BUILD_PATH
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
export VERSION=1.0.0
echo "$ROOT_PATH/linuxdeploy-plugin-appimage-x86_64.AppImage --appdir=$DISTRIB_PATH"
$ROOT_PATH/linuxdeploy-plugin-appimage-x86_64.AppImage --appdir=$DISTRIB_PATH 


