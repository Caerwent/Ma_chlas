QT += quick
QT += multimedia
QT += svg
QT += quickcontrols2
QT += core
CONFIG += c++11

TARGET = Atalierou

macx: ICON = icon.icns
macx: QMAKE_INFO_PLIST = $$PWD/Info.plist

win32:RC_ICONS += icon.ico

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/TreeModel.cpp \
        src/TreeNode.cpp \
        src/configWithPath.cpp \
        src/corpus/corpus.cpp \
        src/fileio.cpp \
        main.cpp \
        src/globalConfigData.cpp \
        src/user.cpp \
        src/ActivityLevelScoreNode.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    Atalierou_fr.ts \
    Atalierou_en.ts \
    Atalierou_br.ts
CONFIG += lrelease
CONFIG += embed_translations


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =


HEADERS += \
    src/ActivityTypeScoreNode.h \
    src/ITreeNode.h \
    src/TreeModel.h \
    src/TreeNode.h \
    src/ActivityCategoryScoreNode.h \
    src/ActivityLevelScoreNode.h \
    src/ActivityScoreNode.h \
    src/VERSION.h \
    src/configWithPath.h \
    src/corpus/CorpusItem.h \
    src/corpus/corpus.h \
    src/fileio.h \
    src/globalConfigData.h \
    src/user.h

#include(./mac.pri)
#include(version_from_git_tag.pri)
