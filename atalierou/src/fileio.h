#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QDir>
#include <QStandardPaths>
class FileIO : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString source
               READ source
               WRITE setSource
               NOTIFY sourceChanged)
    explicit FileIO(QObject *parent = 0);

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString& data);
    Q_INVOKABLE int getNumberOfLines();
    Q_INVOKABLE QString getPath();
    QString source() { return mSource; }

public slots:
    void setSource(const QString& source) { mSource = source;
                                            if(mSource.startsWith("."))
                                            {
                                                mSource = mSource.sliced(1);
                                                mSource = mSource.insert(0, QDir::currentPath());
                                                /*auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
                                                 if (path.isEmpty()) qFatal("Cannot determine settings storage location");
                                                 else
                                                     mSource = mSource.insert(0, path);*/
                                            }}

signals:
    void sourceChanged(const QString& source);
    void error(const QString& msg);

private:
    QString mSource;
};



#endif // FILEIO_H
