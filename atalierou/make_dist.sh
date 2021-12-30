#!/bin/sh

# https://digitalboxweb.wordpress.com/2021/01/20/distribuer-son-editeur-de-texte-multi-plateformes/

DISTRIB_PATH=../distrib/linux_x86-64
BUILD_PATH=../build-Atalierou-Qt_6_2_2_gcc_64
rmdir -rf $DISTRIB_PATH
mkdirs $DISTRIB_PATH
mkdirs $DISTRIB_PATH/plugins/platforms
cp $BUILD_PATH/Atalierou .$DISTRIB_PATH
cp ./icon.png $DISTRIB_PATH
cp ./desktop.entry $DISTRIB_PATH
cp ./Atalierou.sh $DISTRIB_PATH
cp ./qt.conf $DISTRIB_PATH