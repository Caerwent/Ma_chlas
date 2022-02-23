#include "genericconfigwithpath.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QException>


bool GenericConfigWithPath::readContent(QJsonObject &json_obj,  QDir &path)
{

    QJsonObject json_item;
    foreach(const QString& key, json_obj.keys()) {
            if(key!="path" && key!="fileFormatVersion" )
            {
                json_item[key]=json_obj.value(key);
            }
        }
    mJsonContent = QJsonValue(json_item).toVariant();
    emit jsonContentChanged(mJsonContent);
     return true;
}

bool GenericConfigWithPath::writeContent(QJsonObject &json_obj,  QDir &path)
{
    QJsonObject jsonContent=QJsonValue::fromVariant( mJsonContent ).toObject();
    foreach(const QString& key, jsonContent.keys()) {
            json_obj[key]=jsonContent.value(key);
        }


    return true;
}
