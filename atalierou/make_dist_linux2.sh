#!/bin/sh

# https://github.com/probonopd/linuxdeployqt
# make appDir structure
# └── usr
#     ├── bin
#     │   └── Atalierou (compiled binary)
#     ├── lib
#     └── share
#         ├── applications
#         │   └── Atalierou.desktop (from project path)
#         └── icons
#             └── hicolor
#                 └── 512x512 
#                     └── apps 
#                         └── Atalierou.png (from project path)
                        
QT_PATH=../../Qt/6.2.2/gcc_64
BUILD_PATH=../build-Atalierou-Desktop_Qt_6_2_2_GCC_64bit-Release
DISTRIB_PATH=../distrib/linux_x86-64

rm -rf $DISTRIB_PATH
mkdir -p $DISTRIB_PATH
cp $BUILD_PATH/Atalierou $DISTRIB_PATH
cp ./Atalierou.desktop $DISTRIB_PATH
cp ./icon.png $DISTRIB_PATH/Atalierou.png


export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$QT_PATH/lib

export VERSION=1.0.0
../linuxdeployqt-continuous-x86_64.AppImage  $DISTRIB_PATH/Atalierou -qmake=$QT_PATH/bin/qmake -verbose=3 -appimage -bundle-non-qt-libs -extra-plugins=iconengines,platformthemes/libqgtk3.so,platforms/libqxcb.so -always-overwrite  -unsupported-bundle-everything -no-strip -no-translations


#-unsupported-allow-new-glibc


