#ifndef GLOBALCONFIGDATA_H
#define GLOBALCONFIGDATA_H

#include <QObject>
#include <QJsonDocument>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
class GlobalConfigData : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(GlobalConfigData)

public:
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

    Q_INVOKABLE bool save();

    QString externalConfigFile() { return mExternalFile; }
    bool isEmbedded() { return mIsEmbedded; }
    QString language() { return mLanguage; }

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
        emit externalConfigFileChanged(mExternalFile);
    }
    void setIsEmbedded(const bool newValue) {
        mIsEmbedded = newValue;
        emit isEmbeddedChanged(mIsEmbedded);
    }
    void setLanguage(const QString& newValue) {
        mLanguage = newValue;
        emit languageChanged(mLanguage);
    }

signals:
    void externalConfigFileChanged(const QString& externalConfigFile);
    void languageChanged(const QString& language);
    void isEmbeddedChanged(const bool isEmbedded);
    void error(const QString& msg);

public :
    void read();
private:
    QString mExternalFile;
    bool mIsEmbedded=true;
    QString mLanguage;

};
#endif // GLOBALCONFIGDATA_H
