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
    //QFile file(url.toLocalFile());
QFile file(":/res/global_config.json");
    if ( file.open(QIODevice::ReadOnly|QIODevice::Text) ) {
       /* QTextStream jsonStream( &file );
        QString json_string;
        json_string = jsonStream.readAll();
        file.close();
        QByteArray json_bytes = json_string.toLocal8Bit();
*/
        QByteArray data = file.readAll();
        file.close();

        QJsonParseError errorPtr;
        QJsonDocument json_doc = QJsonDocument::fromJson(data, &errorPtr);
        //auto json_doc = QJsonDocument::fromJson(json_bytes);

        if (json_doc.isNull()) {
            qDebug() << "Parse failed " << errorPtr.errorString();
            emit error("Failed to create JSON doc.");
        }
        else if (!json_doc.isObject()) {
            emit error("JSON is not an object.");
        }
        else
        {
            QJsonObject json_obj = json_doc.object();
            if (json_obj.isEmpty()) {
                emit error("JSON object is empty.");
            }
            else
            {
                QVariantMap json_map = json_obj.toVariantMap();
                try {
                    mIsEmbedded = json_map["isEmbeddedConfig"].toBool();
                    mLanguage = json_map["language"].toString();
                    mExternalFile = json_map["externalConfigFile"].toString();
                    if(mSettings)
                    {
                        mSettings->setValue("isEmbedded",mIsEmbedded);
                        mSettings->setValue("language",mLanguage);
                        mSettings->setValue("externaFile",mExternalFile);

                    }
                }  catch (const QException & exp )
                {
                    emit error(QString(exp.what()));
                }

            }
        }
    } else {
        QFileInfo fileInfo(file);
        QString filename(fileInfo.absoluteFilePath());
        emit error("Unable to open the file "+ filename);
    }

    loadLanguage();

}

bool GlobalConfigData::save()
{
    QJsonObject json_obj;
    json_obj["isEmbeddedConfig"] = mIsEmbedded;
    json_obj["language"] = mLanguage;
    json_obj["externalConfigFile"] = mExternalFile;

    QJsonDocument json_doc(json_obj);
    QString json_string = json_doc.toJson();

    QUrl url(QStringLiteral("qrc:/res/global_config.json"));

    QFile file(url.toLocalFile());
    if(!file.open(QIODevice::WriteOnly)){
        emit error("failed to open save file");
        return false;
    }
    else
    {
        file.write(json_string.toLocal8Bit());
        file.close();

        if(mSettings)
        {
            mSettings->setValue("isEmbedded",mIsEmbedded);
            mSettings->setValue("language",mLanguage);
            mSettings->setValue("externaFile",mExternalFile);

        }
        return true;
    }

}

void GlobalConfigData::loadLanguage(){
    if(mApp && mEngine && !mLanguage.isEmpty())
    {
        bool needToRetranslate = false;
        if(mTranslator)
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



