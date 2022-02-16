#include "configwithpath.h"
#include <QDir>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QException>
#include <QRegularExpression>
#include <QtDebug>

const QString ConfigWithPath::getPathAbsolute()
{
    QDir path=QDir(mPath);

    QDir sourcePath=QDir(mFilePath);

    if(path.isRelative())
    {
        path = QDir(sourcePath.canonicalPath()+QDir::separator()+path.path());
    }

    return path.canonicalPath()+QDir::separator();
}
const QString ConfigWithPath::getFilenameRelativeToPath(const QString &filename)
{
   // qDebug() << "getFilenameRelativeToPath mPath=" << mPath << " mFilePath=" << mFilePath<< " filename=" << filename;

    QDir path=QDir(mPath);
   // qDebug() << "getFilenameRelativeToPath path=" << path.path();

    QDir sourcePath=QDir(mFilePath);
   // qDebug() << "getFilenameRelativeToPath sourcePath=" << sourcePath.path();

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
   // qDebug() << "getFilenameRelativeToPath after path isRelative check path=" << path.path();

    return path.relativeFilePath(destFilename);
}

bool ConfigWithPath::updateFileLocationInfo(const QString &filename, bool checkExists)
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


bool ConfigWithPath::read(const QString &filename)
{
  //  qDebug() << "read filename=" << filename ;

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
            if(!json_obj.contains("fileFormatVersion"))
            {
                emit error(tr("JSON object doesn't contain fileFormatVersion."));
                return false;
            }
            auto charsMin = mRequieredMinVersion.split(QString("."));
            auto charsMax = mRequieredMinVersion.split(QString("."));
            QRegularExpression regexp("^(["+charsMin.at(0)+"-"+charsMax.at(0)+"])\\.(["+charsMin.at(1)+"-"+charsMax.at(1)+"])\\.(\\d+)");

             QRegularExpressionMatch match = regexp.match(json_obj.value("fileFormatVersion").toString());
            if(!match.hasMatch())
            {
                emit error(tr("Unsupported fileFormatVersion, should be between %1 and %2.").arg(mRequieredMinVersion, mRequieredMaxVersion));
                return false;
            }


            if(!json_obj.contains("path"))
            {
                emit error(tr("JSON object doesn't contain path."));
                return false;
            }

            //qDebug() << "path "<<json_obj.value("path").toString();
            mPath = json_obj.value("path").toString();
            if(mPath.isEmpty())
            {
                mPath="./";
            }
            if(!mPath.endsWith(QDir::separator()))
            {
                mPath.append(QDir::separator());
            }
            emit pathChanged(mPath);
            QDir path=QDir(mPath);
            if(path.isRelative())
            {
                QFileInfo fileInfo(file);
                path = QDir(fileInfo.absolutePath());

            }
            return readContent(json_obj, path);


    }
    return true;
}


bool ConfigWithPath::save()
{
    QFile file(mFileLocation);
    if(!file.open(QIODevice::WriteOnly|QFile::Truncate)){
        emit error(tr("failed to write file %1").arg(mFileLocation));
        return false;
    }

    try {
        QJsonObject json_obj;

        json_obj["fileFormatVersion"] = this->getFileFormatVersion();

        json_obj["path"] = mPath;

        QDir path=QDir(mPath);
        if(path.isRelative())
        {
            QFileInfo fileInfo(file);
            path = QDir(fileInfo.absolutePath());

        }

        this->writeContent(json_obj, path);
        QJsonDocument json_doc(json_obj);
        QString json_string = json_doc.toJson();
        file.write(json_string.toLocal8Bit());
        file.close();

        return true;
    }
    catch (const QException & exp )
    {
        emit error(QString(exp.what()));
        return false;
    }
}
bool ConfigWithPath::saveAs(const QString &filename, const QString &refPathToUse)
{
    if (!updateFileLocationInfo(filename, false)){
        return false;
    }
    emit filenameChanged(mFileLocation);
    mPath = refPathToUse;
    if(!mPath.endsWith(QDir::separator()))
    {
        mPath.append(QDir::separator());
    }
    emit pathChanged(mPath);
    return save();

}
