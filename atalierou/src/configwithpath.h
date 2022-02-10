#ifndef CONFIGWITHPATH_H
#define CONFIGWITHPATH_H
#include <QObject>
#include <QJsonObject>
#include <QDir>

class ConfigWithPath: public QObject {
            Q_OBJECT

            Q_PROPERTY(QString filename
                       READ filename
                       WRITE setFilename
                       NOTIFY filenameChanged)
            Q_PROPERTY(QString path
                       READ path
                       NOTIFY pathChanged)
        public:
            explicit ConfigWithPath(QObject *parent = 0): QObject(parent) {}

    Q_INVOKABLE const QString getFilenameRelativeToPath(const QString &filename);
    Q_INVOKABLE const QString getPathAbsolute();
    QString filename() { return mFileLocation; }
    QString path() { return mPath; }
    Q_INVOKABLE void reset() {
        mFileLocation="";
        mFilePath="";
        mPath="";
        emit filenameChanged(mFileLocation);
        emit pathChanged(mPath);

    }
    Q_INVOKABLE bool read(const QString &filename);
    Q_INVOKABLE bool save();
    Q_INVOKABLE bool saveAs(const QString &filename, const QString &refPathToUse);

public slots:
    void setFilename(const QString& filename) {updateFileLocationInfo(filename, false);}

signals:
    void filenameChanged(const QString& filename);
    void pathChanged(const QString& path);
    void error(const QString& msg);

protected:

    virtual bool writeContent(QJsonObject &json_obj,  QDir &path) = 0;
    virtual bool readContent(QJsonObject &json_obj,  QDir &path) = 0;
private:
    bool updateFileLocationInfo(const QString &filename, bool checkExists);

    QString mFileLocation;
    QString mFilePath;
    QString mPath;
};

#endif // CONFIGWITHPATH_H
