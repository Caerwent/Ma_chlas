#include "corpus.h"

#include <QDir>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QException>
#include <QtDebug>


bool Corpus::removeItemAt(int idx)
{
    if(idx>0 && idx<mItems.size())
    {
        mItems.removeAt(idx);
        emit itemsChanged();
        return true;
    }
    return false;
}
void Corpus::addItem(CorpusItem* item) {
    mItems.append(item);
    emit itemsChanged();
}
const QString Corpus::getPathAbsolute()
{
    QDir path=QDir(mCorpusPath);

    QDir sourcePath=QDir(mFilePath);

    if(path.isRelative())
    {
        path = QDir(sourcePath.canonicalPath()+QDir::separator()+path.path());
    }

    return path.canonicalPath()+QDir::separator();
}
const QString Corpus::getFilenameRelativeToCorpus(const QString &filename)
{
   // qDebug() << "getFilenameRelativeToCorpus mCorpusPath=" << mCorpusPath << " mFilePath=" << mFilePath<< " filename=" << filename;

    QDir path=QDir(mCorpusPath);
   // qDebug() << "getFilenameRelativeToCorpus path=" << path.path();

    QDir sourcePath=QDir(mFilePath);
   // qDebug() << "getFilenameRelativeToCorpus sourcePath=" << sourcePath.path();

    QString destFilename;
    if(filename.startsWith("file:"))
    {
        QUrl url(filename);
        destFilename=url.toLocalFile();
    } else {
        destFilename=filename;
    }

    if(path.isRelative())
    {
        path = QDir(sourcePath.canonicalPath()+QDir::separator()+path.path());
    }
   // qDebug() << "getFilenameRelativeToCorpus after path isRelative check path=" << path.path();

    return path.relativeFilePath(destFilename);
}

bool Corpus::updateFileLocationInfo(const QString &filename, bool checkExists)
{
   qDebug() << "updateFileLocationInfo filename=" << filename;
    if(filename.startsWith("."))
    {
        mFileLocation = filename.sliced(1);
        mFileLocation = mFileLocation.insert(0, QDir::currentPath());

    } else if(filename.startsWith("file:"))
    {
        QUrl url(filename);
        mFileLocation=url.toLocalFile();
    }
   // qDebug() << "updateFileLocationInfo mFileLocation=" << mFileLocation;
    QFile file(mFileLocation);

    if ( checkExists && !file.exists() )
    {
        emit error(tr("File doesn't exist: %1").arg(mFileLocation));
        return false;
    }
    QFileInfo fileInfo(file);
    mFilePath = fileInfo.absolutePath();
   // qDebug() << "updateFileLocationInfo mFilePath=" << mFilePath;
    return true;
}
bool Corpus::read(const QString &filename)
{
  //  qDebug() << "read filename=" << filename ;
    mItems.clear();

    if (!updateFileLocationInfo(filename, true)){
        return false;
    }

    emit filenameChanged(mFileLocation);

    QFile file(mFileLocation);


        if(file.open(QIODevice::ReadOnly|QIODevice::Text) )
        {
       // qDebug() << "open filename=" << mFileLocation ;
            QByteArray data = file.readAll();
            file.close();


            QJsonParseError errorPtr;
            QJsonDocument json_doc = QJsonDocument::fromJson(data, &errorPtr);

            if (json_doc.isNull()) {
               // qDebug() << "Parse failed " << errorPtr.errorString();
                emit error(tr("Failed to load JSON doc %1").arg(mFileLocation));
                return false;
            }
            else if (!json_doc.isObject()) {
                emit error(tr("JSON root is not an object in file %1").arg(mFileLocation));
                return false;
            }

            QJsonObject json_obj = json_doc.object();
            if (json_obj.isEmpty()) {
                emit error(tr("JSON object is empty."));
                return false;
            }

            if(!json_obj.contains("path"))
            {
                emit error(tr("JSON object doesn't contain path."));
                return false;
            }
            //qDebug() << "path "<<json_obj.value("path").toString();
            mCorpusPath = json_obj.value("path").toString();
            if(mCorpusPath.isEmpty())
            {
                mCorpusPath="./";
            }
            if(!mCorpusPath.endsWith(QDir::separator()))
            {
                mCorpusPath.append(QDir::separator());
            }
            emit pathChanged(mCorpusPath);
            QDir path=QDir(mCorpusPath);
            if(path.isRelative())
            {
                QFileInfo fileInfo(file);
                path = QDir(fileInfo.absolutePath());

            }
            if(!json_obj.contains("items"))
            {
                emit error(tr("JSON object doesn't contain items."));
                return false;
            }
            try {

                QJsonArray items = json_obj["items"].toArray();
                for ( const auto &item : items)
                {
                    QJsonObject currItem = item.toObject();

                    if(!currItem.contains("id"))
                    {
                        emit error(tr("JSON item doesn't contain %1: %2").arg("id", item.toString()));
                        return false;
                    }
                    if(!currItem.contains("image"))
                    {
                        emit error(tr("JSON item doesn't contain %1: %2").arg("image", item.toString()));
                        return false;
                    }
                    if(!currItem.contains("sound"))
                    {
                        emit error(tr("JSON item doesn't contain %1: %2").arg("sound", item.toString()));
                        return false;
                    }
                    if(!currItem.contains("nbSyllabes"))
                    {
                        emit error(tr("JSON item doesn't contain %1: %2").arg("nbSyllabes", item.toString()));
                        return false;
                    }

                    CorpusItem* newItem=new CorpusItem(nullptr);
                    newItem->corpusId(currItem.value("id").toString());
                    // resolve file position using path info and json file location
                    newItem->image(path.relativeFilePath(currItem.value("image").toString()));
                    newItem->sound(path.relativeFilePath(currItem.value("sound").toString()));
                    newItem->nbSyllabes(currItem.value("nbSyllabes").toInt());

                    mItems.append(newItem);
                }

                emit itemsChanged();
            }  catch (const QException & exp )
            {
                emit error(QString(exp.what()));
                return false;
            }


    }

    return true;
}

bool Corpus::save()
{
    QFile file(mFileLocation);
    if(!file.open(QIODevice::WriteOnly|QFile::Truncate)){
        emit error(tr("failed to write file %1").arg(mFileLocation));
        return false;
    }

    try {
        QJsonObject json_obj;
        json_obj["path"] = mCorpusPath;
        QJsonArray jsonItems;

        QDir path=QDir(mCorpusPath);
        if(path.isRelative())
        {
            QFileInfo fileInfo(file);
            path = QDir(fileInfo.absolutePath());

        }

        for (int i=0;i<mItems.size();i++)
        {

            QJsonObject json_item;
            json_item["id"] = mItems[i]->corpusId();
            json_item["image"] = path.relativeFilePath(mItems[i]->image());
            json_item["sound"] = path.relativeFilePath(mItems[i]->sound());
            json_item["nbSyllabes"] = mItems[i]->nbSyllabes();
            jsonItems.append(json_item);

        }
        json_obj["items"] = jsonItems;
        QJsonDocument json_doc(json_obj);
        QString json_string = json_doc.toJson();
        file.write(json_string.toLocal8Bit());
        file.close();


        emit itemsChanged();
        return true;
    }
    catch (const QException & exp )
    {
        emit error(QString(exp.what()));
        return false;
    }
}
bool Corpus::saveAs(const QString &filename, const QString &refPathToUse)
{
    if (!updateFileLocationInfo(filename, false)){
        return false;
    }
    emit filenameChanged(mFileLocation);
    mCorpusPath = refPathToUse;
    if(!mCorpusPath.endsWith(QDir::separator()))
    {
        mCorpusPath.append(QDir::separator());
    }
    emit pathChanged(mCorpusPath);
    return save();

}


