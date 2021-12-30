#include "src/globalConfigData.h"
#include <QFile>
#include <QUrl>
#include <QFileInfo>
#include <QTextStream>
#include <QTranslator>
#include <QJsonObject>
#include <QException>
GlobalConfigData::GlobalConfigData(QObject *parent) :
    QObject(parent)
{
}

void GlobalConfigData::read() {

    //QUrl url(QStringLiteral("qrc:/res/global_config.json"));

    if(mSettings)
    {
        mIsEmbedded = mSettings->value("isEmbedded", false).toBool();
        mLanguage = mSettings->value("language", "en").toString();
        mExternalFile = mSettings->value("externaFile", "").toString();
    }
    else {
        mIsEmbedded=true;
        mLanguage="fr";
        mExternalFile="";
    }
    loadLanguage();

}


void GlobalConfigData::loadLanguage(){
    if(mApp && mEngine && !mLanguage.isEmpty())
    {
        bool needToRetranslate = false;
        if(mTranslator!= nullptr)
        {
            mApp->removeTranslator(mTranslator);
            needToRetranslate=true;
            delete mTranslator;
        }
        mTranslator = new QTranslator();
        const QString baseName = "Atalierou_" + QLocale(mLanguage).name();
        if (mTranslator->load(":/i18n/" + baseName)) {
            if(mApp->installTranslator(mTranslator))
            {
                if(needToRetranslate) mEngine->retranslate();
            } else
            {
                qDebug()<<"Error when installing language "<<baseName;
                emit error("Error when installing language "+baseName);
            }
        }
    }
}



