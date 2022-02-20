#include "src/fileio.h"
#include <QFile>
#include <QFileInfo>
#include <QTextStream>
#include <QUrl>

FileIO::FileIO(QObject *parent) :
    QObject(parent)
{

}

QString FileIO::getPath()
{
    if (mSource.isEmpty()){
        emit error(tr("file name is empty"));
        return QString();
    }
    QString src;
    if(mSource.startsWith("file://"))
    {
        QUrl url(mSource);
        src=url.toLocalFile();
    }
    else
    {
        src = mSource;
    }
    QFile file(src);
    QFileInfo fileInfo(file);
    return fileInfo.canonicalPath()+"/";
}

QString FileIO::read()
{
    if (mSource.isEmpty()){
        emit error(tr("file name is empty"));
        return QString();
    }
    QString src;
    if(mSource.startsWith("file://"))
    {
        QUrl url(mSource);
        src=url.toLocalFile();
    }
    else
    {
        src = mSource;
    }
    QFile file(src);
    QString fileContent;
    if ( file.open(QIODevice::ReadOnly) ) {
        QString line;
        QTextStream t( &file );
        do {
            line = t.readLine();
            fileContent += line;
         } while (!line.isNull());

        file.close();
    } else {
        QFileInfo fileInfo(file);
        QString filename(fileInfo.absoluteFilePath());
        emit error(tr("Unable to open file %1").arg(filename));
                return QString();
            }
            return fileContent;
}

int FileIO::getNumberOfLines(){

    if (mSource.isEmpty()){
        emit error(tr("file name is empty"));
        return -1;
    }

    QFile file(mSource);
    int numberOfLines=0;

    if ( file.open(QIODevice::ReadOnly) ) {
        QString line;
        QTextStream t( &file );
        do {
           line = t.readLine();
           numberOfLines++;
         } while (!line.isNull());

        file.close();
    } else {
        emit error(tr("Unable to open file %1").arg(mSource));
                return -1;
            }
            return numberOfLines-1;
}

bool FileIO::write(const QString& data)
{
   if (mSource.isEmpty())
       return false;

    QFile file(mSource);
    //"append" allows adding a new line instead of rewriting the file
     if (!file.open(QFile::WriteOnly | QIODevice::Text | QFile::Append))
     {
         emit error(tr("Unable to write file %1").arg(mSource));
          return false;
     }

    QTextStream out(&file);
       out << data <<"\n";

       file.close();

    return true;
}
