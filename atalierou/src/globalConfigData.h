#ifndef GLOBALCONFIGDATA_H
#define GLOBALCONFIGDATA_H

#include <QObject>
#include <QJsonDocument>
#include <QQmlApplicationEngine>
#include <QApplication>
#include <QLocale>
#include <QTranslator>
#include <QSettings>

#include "user.h"
#include "VERSION.h"


class GlobalConfigData : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(GlobalConfigData)

public:

    Q_PROPERTY(QString version
               READ version
               NOTIFY versionChanged)
               
    Q_PROPERTY(QString externalConfigFile
               READ externalConfigFile
               WRITE setExternalConfigFile
               NOTIFY externalConfigFileChanged)

    Q_PROPERTY(bool isEmbedded
               READ isEmbedded
               WRITE setIsEmbedded
               NOTIFY isEmbeddedChanged)

    Q_PROPERTY(QString language
               READ language
               WRITE setLanguage
               NOTIFY languageChanged)

    explicit GlobalConfigData(QObject *parent = 0);
    ~GlobalConfigData()
    {
        delete mTranslator;
    }

    QString externalConfigFile() { return mExternalFile; }
    bool isEmbedded() { return mIsEmbedded; }
    QString language() { return mLanguage; }
    QString version() { return QString(VERSION); }


    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
      {
        Q_UNUSED(engine);
        Q_UNUSED(scriptEngine);

          auto val = new GlobalConfigData;
          val->read();
          return val;
    }

public slots:
    void setExternalConfigFile(const QString& newValue) {
        mExternalFile = newValue;
        if(mSettings)
        {
            mSettings->setValue("externaFile",  mExternalFile);
        }
        emit externalConfigFileChanged(mExternalFile);
    }
    void setIsEmbedded(const bool newValue) {
        mIsEmbedded = newValue;
        if(mSettings)
        {
           mSettings->setValue("isEmbedded",  mIsEmbedded);
        }
        emit isEmbeddedChanged(mIsEmbedded);
    }
    void setLanguage(const QString& newValue) {
        mLanguage = newValue;
        if(mSettings)
        {
           mSettings->setValue("language",  mLanguage);
        }
        emit languageChanged(mLanguage);
        loadLanguage();
    }


signals:
    void externalConfigFileChanged(const QString& externalConfigFile);
    void languageChanged(const QString& language);
    void isEmbeddedChanged(const bool isEmbedded);
    void versionChanged(const QString& version);
    void error(const QString& msg);

public :
    void read();

    void setApp(QApplication* app) {mApp = app;}
    void setEngine(QQmlEngine* engine) {mEngine = engine;}
    void setSettings(QSettings* settings) {mSettings = settings;}
private :
     void loadLanguage();
private:
    QString mExternalFile;
    bool mIsEmbedded=true;
    QString mLanguage="fr";
    QApplication* mApp = nullptr;
    QQmlEngine* mEngine = nullptr;
    QSettings* mSettings = nullptr;
    QTranslator* mTranslator = nullptr;

};
#endif // GLOBALCONFIGDATA_H
