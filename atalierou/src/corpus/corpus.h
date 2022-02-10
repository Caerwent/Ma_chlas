#ifndef CORPUS_H
#define CORPUS_H

#include <QObject>
#include <QJsonObject>
#include <QDir>
#include "CorpusItem.h"
#include "../configwithpath.h"
class Corpus : public ConfigWithPath
{
    Q_OBJECT


public:
    explicit Corpus(QObject *parent = 0): ConfigWithPath(parent) {}
    ~Corpus(){
        mItems.clear();
    }


    Q_INVOKABLE void reset() {
        mItems.clear();
        ConfigWithPath::reset();
    }

    Q_INVOKABLE QList<CorpusItem*> getItems() {return mItems;}
    Q_INVOKABLE bool removeItemAt(int idx);
    Q_INVOKABLE void addItem(CorpusItem* item);


signals:
    void itemsChanged();

protected:

    bool writeContent(QJsonObject &json_obj,  QDir &path) Q_DECL_OVERRIDE;
    bool readContent(QJsonObject &json_obj,  QDir &path) Q_DECL_OVERRIDE;

private:

    QList<CorpusItem*> mItems;

};

#endif // CORPUS_H
