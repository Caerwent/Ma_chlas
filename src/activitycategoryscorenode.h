#ifndef ACTIVITYCATEGORYSCORENODE_H
#define ACTIVITYCATEGORYSCORENODE_H

#include "TreeNode.h"
#include "ActivityTypeScoreNode.h"

class ActivityCategoryScoreNode : public TreeNode
{
     Q_OBJECT
public:
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(int meanScore READ meanScore NOTIFY meanScoreChanged)
    explicit ActivityCategoryScoreNode(QObject *parent = nullptr) : TreeNode(parent)
    {

    }
    ~ActivityCategoryScoreNode() {}

    QVariant display() const Q_DECL_OVERRIDE {
        return QVariant(QString(mName).append(" ").append(QString::number(mMeanScore)).append("%"));
    }
    QString name() { return mName; }
     int meanScore() { return mMeanScore; }

     void setName(const QString name) { mName = name;}
     void setMeanScore(int score) { mMeanScore = score;}

     bool addScore(const QString& activityType, const int activityLevel, int score) {
     qDebug() << "ActivityCategoryScoreNode::addScore " << activityType << " " <<activityLevel << " " <<score;
         auto typesNodes = getTreeNodes();
         bool found=false;
          bool added=false;
         foreach (TreeNode * typeNode, typesNodes)
         {

             ActivityTypeScoreNode* currentType = static_cast<ActivityTypeScoreNode*>(const_cast<TreeNode*>(typeNode));

             if(currentType->name().compare(activityType,  Qt::CaseInsensitive)==0)
             {
                 qDebug() << "type found ";
                 added=currentType->addScore(activityLevel, score);
                 found=true;
                 break;
             }
         }
         if(!found)
         {
             ActivityTypeScoreNode* type = new ActivityTypeScoreNode();
             insertNode(type);
             type->setParentNode(this);
             type->setName(activityType);
             added = type->addScore(activityLevel, score);
         }
         return added;
     }
signals:
    void meanScoreChanged(const int meanScore);

private:
    int mMeanScore;
     QString mName;
};

#endif // ACTIVITYCATEGORYSCORENODE_H
