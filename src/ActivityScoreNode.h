#ifndef ACTIVITYSCORENODE_H
#define ACTIVITYSCORENODE_H

#include <QDateTime>
#include "TreeNode.h"

#define DATE_FORMAT "yyyy MM dd - hh:mm:ss"

class ActivityScoreNode : public TreeNode
{
     Q_OBJECT
public:
    Q_PROPERTY(int score READ score)
    Q_PROPERTY(QDateTime date READ date)
    explicit ActivityScoreNode(QObject *parent = nullptr) : TreeNode(parent)
    {

    }
    ~ActivityScoreNode() {}
    QVariant display() const Q_DECL_OVERRIDE {
        return QVariant(mDate.toString(DATE_FORMAT).append(" ").append(QString::number(mScore)).append("%"));
    }
     int score() { return mScore; }
     QDateTime date() { return mDate; }
     QString dateString() { return mDate.toString(DATE_FORMAT);}


     void setScore(int score) {
         mScore=score;
     }

     void setDate(const QDateTime &date)
     {
         mDate = date;
     }

     bool setDate(const QString dateString)
     {
         QDateTime newDate = QDateTime::fromString(dateString,DATE_FORMAT);
         if(newDate.isValid())
         {
             mDate = newDate;
             return true;
         }
         else
         {
             return false;
         }
     }

signals:
    void lockedChanged(const int locked);


private:
    int mScore=0;
    QDateTime mDate;
};

#endif // ACTIVITYSCORENODE_H
