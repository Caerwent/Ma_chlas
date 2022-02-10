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


bool Corpus::readContent(QJsonObject &json_obj,  QDir &path)
{

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
        return true;
    }  catch (const QException & exp )
    {
        emit error(QString(exp.what()));
        return false;
    }
}
bool Corpus::writeContent(QJsonObject &json_obj,  QDir &path)
{

    try {
 QJsonArray jsonItems;
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



        emit itemsChanged();
        return true;
    }
    catch (const QException & exp )
    {
        emit error(QString(exp.what()));
        return false;
    }
}


