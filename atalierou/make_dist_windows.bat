#!/bin/sh

# https://github.com/probonopd/linuxdeployqt

set QT_PATH=../../Qt/6.2.2
set QTDEPLOY=%QT_PATH%/bin/windeployqt
set BUILD_PATH=../build-Atalierou-Desktop_Qt_6_2_2_XXX-Release

QTDEPLOY -qmake=%QT_PATH%/bin/ -verbose=3 %BUILD_PATH%/Atalierou.exe



