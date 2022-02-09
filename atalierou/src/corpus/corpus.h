#ifndef CORPUS_H
#define CORPUS_H

#include <QObject>
#include <QJsonObject>
#include "CorpusItem.h"
class Corpus : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString filename
               READ filename
               WRITE setFilename
               NOTIFY filenameChanged)
    Q_PROPERTY(QString path
               READ path
               NOTIFY pathChanged)
public:
    explicit Corpus(QObject *parent = 0): QObject(parent) {}
    ~Corpus(){
        mItems.clear();
    }



    Q_INVOKABLE bool read(const QString &filename);
    Q_INVOKABLE bool save();
    Q_INVOKABLE bool saveAs(const QString &filename, const QString &refPathToUse);
    Q_INVOKABLE QList<CorpusItem*> getItems() {return mItems;}
    Q_INVOKABLE bool removeItemAt(int idx);
    Q_INVOKABLE void addItem(CorpusItem* item);
    Q_INVOKABLE const QString getFilenameRelativeToCorpus(const QString &filename);
    Q_INVOKABLE const QString getPathAbsolute();
    QString filename() { return mFileLocation; }
    QString path() { return mCorpusPath; }


public slots:
    void setFilename(const QString& filename) {updateFileLocationInfo(filename, false);}

signals:
    void filenameChanged(const QString& filename);
    void pathChanged(const QString& path);
    void itemsChanged();
    void error(const QString& msg);

private:
    bool updateFileLocationInfo(const QString &filename, bool checkExists);

    QList<CorpusItem*> mItems;
    QString mFileLocation;
    QString mFilePath;
    QString mCorpusPath;
};

#endif // CORPUS_H
