#!/bin/sh

# https://github.com/probonopd/linuxdeployqt

QT_PATH=../../Qt/6.2.2/gcc_64/bin
BUILD_PATH=../build-Atalierou-Desktop_Qt_6_2_2_GCC_64bit-Release

../../linuxdeployqt-continuous-x86_64.AppImage -qmake=$QT_PATH -appimage -verbose=3 Atalierou.desktop


