#!/bin/sh

# https://digitalboxweb.wordpress.com/2021/01/20/distribuer-son-editeur-de-texte-multi-plateformes/

DISTRIB_PATH=../distrib/linux_x86-64
BUILD_PATH=../build-Atalierou-Desktop_Qt_6_2_2_GCC_64bit-Release
LIBS_PATH=$DISTRIB_PATH/libs
rm -rf $DISTRIB_PATH
mkdir -p $DISTRIB_PATH
mkdir -p $LIBS_PATH
mkdir -p $DISTRIB_PATH/plugins/platforms
cp $BUILD_PATH/Atalierou $DISTRIB_PATH
cp ./icon.png $DISTRIB_PATH
cp ./desktop.entry $DISTRIB_PATH
cp ./Atalierou.sh $DISTRIB_PATH
cp ./qt.conf $DISTRIB_PATH

ldd $BUILD_PATH/Atalierou  | column -t -d -H 1,2,4 -s " " | grep Qt | xargs cp -t $LIBS_PATH
ldd $BUILD_PATH/Atalierou  | column -t -d -H 1,2,4 -s " " | grep xcb.so | xargs cp -t $DISTRIB_PATH/plugins/platforms

