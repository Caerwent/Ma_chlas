#!/bin/sh

#export QT_PATH=../../Qt/6.2.2/gcc_64
export QT_PATH=$(realpath ../Qt/6.2.2/gcc_64)
echo $QT_PATH

#export PATH=$QT_PATH/bin:$PATH
#export LD_LIBRARY_PATH=$QT_PATH/lib:$LD_LIBRARY_PATH
#export QT_INSTALL_QML=$QT_PATH/qml
#export QT_PLUGIN_PATH=$QT_PATH/plugins
#export QML2_IMPORT_PATH=$QT_PATH/qml
#export QML_IMPORT_PATH=$QT_PATH/qml

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

#cp $BUILD_PATH/Atalierou $DISTRIB_PATH

cd $ROOT_PATH

#https://opensourcelibs.com/lib/linuxdeploy-plugin-qt
#https://github.com/linuxdeploy
export QMAKE=$QT_PATH/bin/qmake
export DEBUG=1
#export QML_SOURCES_PATHS=$PROJECT_PATH/ui
#export QML_MODULES_PATHS=$QT_PATH/qml:$QT_PATH/qml/QtQuick:$QT_PATH/qml/QtQuick/Dialogs:$QT_PATH/qml/QtQuick/Controls:$QT_PATH/qml/QtQuick/Particules:$QT_PATH/qml/QtQuick/NativeStyle:$QT_PATH/qml/QtQuick/NativeStyle/controls:$QT_PATH/qml/QtQuick/Templates:$QT_PATH/qml/QtQuick/Controls/Basic:$QT_PATH/qml/QtQuick/Controls/Fusion:$QT_PATH/qml/QtQuick/Controls/Material:$QT_PATH/qml/QtQuick/Controls/impl:$QT_PATH/qml/QtQuick/Controls/Universal
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
#../linuxdeploy-plugin-qt-x86_64.AppImage --appdir=$DISTRIB_PATH --extra-plugin=svg;platforminputcontexts;multimedia;iconengines;platformthemes;platforms;accessiblebridge;imageformats;accessible;networkaccess;qtquickcontrols2 --output appimage

echo =========================================================================================
echo ==================================== linuxdeploy appimage ===============================
echo =========================================================================================
export VERSION=1.0.0
echo "$ROOT_PATH/linuxdeploy-plugin-appimage-x86_64.AppImage --appdir=$DISTRIB_PATH"
$ROOT_PATH/linuxdeploy-plugin-appimage-x86_64.AppImage --appdir=$DISTRIB_PATH 

