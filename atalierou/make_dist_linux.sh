#!/bin/sh

# https://github.com/probonopd/linuxdeployqt

QT_PATH=../../Qt/6.2.2/gcc_64/bin
BUILD_PATH=../build-Atalierou-Desktop_Qt_6_2_2_GCC_64bit-Release
DISTRIB_PATH=../distrib/linux_x86-64
rm -rf $DISTRIB_PATH
mkdir -p $DISTRIB_PATH
cp $BUILD_PATH/Atalierou $DISTRIB_PATH
cp ./icon.png $DISTRIB_PATH
cp ./Atalierou.desktop $DISTRIB_PATH

cd $DISTRIB_PATH
../../../../linuxdeployqt-continuous-x86_64.AppImage -qmake=$QT_PATH -appimage -verbose=3 Atalierou.desktop


