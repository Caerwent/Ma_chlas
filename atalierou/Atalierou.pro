QT += quick
QT += multimedia
QT += svg
QT += widgets
QT += quickcontrols2
QT += core5compat
QT += core
CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/TreeModel.cpp \
        src/TreeNode.cpp \
        src/fileio.cpp \
        main.cpp \
        src/globalConfigData.cpp \
        src/user.cpp \
        src/ActivityLevelScoreNode.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    Atalierou_fr_FR.ts
CONFIG += lrelease
CONFIG += embed_translations

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/ActivityTypeScoreNode.h \
    src/ITreeNode.h \
    src/TreeModel.h \
    src/TreeNode.h \
    src/ActivityCategoryScoreNode.h \
    src/ActivityLevelScoreNode.h \
    src/ActivityScoreNode.h \
    src/fileio.h \
    src/globalConfigData.h \
    src/user.h

DISTFILES += \
    data/config.json \
    data/images/image1.jpg \
    data/images/image2.jpg \
    data/images/image3.jpg \
    data/images/image4.jpg \
    data/models/phonem.json \
    data/sounds/phoneme1.mp3 \
    data/sounds/phoneme2.mp3 \
    data/sounds/phoneme3.mp3 \
    data/sounds/phoneme4.mp3 \
    data/sounds/quiSon1R1.mp3 \
    data/sounds/quiSon1R2.mp3 \
    data/sounds/quiSon1R3.mp3 \
    data/sounds/quiSon1R4.mp3 \
    data/sounds/sample-3s.mp3
