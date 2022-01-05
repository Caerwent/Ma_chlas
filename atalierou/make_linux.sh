#!/bin/sh

QT_PATH=../../Qt/6.2.2/gcc_64

echo $QT_PATH
BUILD_PATH=../build-Atalierou-Desktop_Qt_6_2_2_GCC_64bit-Release
DISTRIB_PATH=../distrib/linux_x86-64
PROJECT_PATH=../atalierou

rm -rf $DISTRIB_PATH
mkdir -p $DISTRIB_PATH
rm -rf $BUILD_PATH
mkdir -p $BUILD_PATH
cd $BUILD_PATH

$QT_PATH/bin/qmake6 -o Makefile $PROJECT_PATH/Atalierou.pro -spec linux-g++ CONFIG+=qtquickcompiler 

make -f Makefile qmake_all
 
make -j6
