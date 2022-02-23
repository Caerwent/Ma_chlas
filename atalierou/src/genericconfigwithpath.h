#ifndef GENERICCONFIGWITHPATH_H
#define GENERICCONFIGWITHPATH_H

#include "configwithpath.h"
#include <QObject>
#include <QJsonObject>

class GenericConfigWithPath : public ConfigWithPath
{
    Q_OBJECT
    Q_PROPERTY(QString fileFormatVersion
               READ fileFormatVersion
               WRITE fileFormatVersion
               NOTIFY fileFormatVersionChanged)

    Q_PROPERTY(QVariant jsonContent
               READ jsonContent
               WRITE jsonContent
               NOTIFY jsonContentChanged)



public:
     explicit GenericConfigWithPath(QObject *parent = 0): ConfigWithPath(parent) {}


    QString fileFormatVersion() { return mFileFormatVersion; }
    QVariant jsonContent() { return mJsonContent; }

    Q_INVOKABLE void reset() {
        mJsonContent.clear();

        ConfigWithPath::reset();
        emit jsonContentChanged(mJsonContent);
    }

public slots:
    void fileFormatVersion(const QString& fileFormatVersion) { mFileFormatVersion = fileFormatVersion;}
    void jsonContent(const QVariant& fileContent) { mJsonContent = fileContent;}

signals:
    void fileFormatVersionChanged(const QString& fileFormatVersion);
    void jsonContentChanged(const QVariant& fileContent);

protected :
    QString getFileFormatVersion() const Q_DECL_OVERRIDE { return mFileFormatVersion;} ;
    bool writeContent(QJsonObject &json_obj,  QDir &path) Q_DECL_OVERRIDE;
    bool readContent(QJsonObject &json_obj,  QDir &path) Q_DECL_OVERRIDE;

private :
    QString mFileFormatVersion;
    QVariant mJsonContent;
};

#endif // GENERICCONFIGWITHPATH_H
