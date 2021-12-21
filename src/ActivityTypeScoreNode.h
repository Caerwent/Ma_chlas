#ifndef ACTIVITYTYPESCORENODE_H
#define ACTIVITYTYPESCORENODE_H

#include "TreeNode.h"
#include "ActivityLevelScoreNode.h"

class ActivityTypeScoreNode : public TreeNode
{
     Q_OBJECT
public:
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(int meanScore READ meanScore NOTIFY meanScoreChanged)

    explicit ActivityTypeScoreNode(QObject *parent = nullptr) : TreeNode(parent)
    {

    }
    ~ActivityTypeScoreNode() {}

    QVariant display() const Q_DECL_OVERRIDE {
        return QVariant(QString(mName).append(" - ").append(QString::number(mMeanScore)).append("%"));
    }
    QString name() { return mName; }
     int meanScore() { return mMeanScore; }

     void setName(const QString name) { mName = name;}
     void setMeanScore(int score) { mMeanScore = score;}

    bool addScore(const int activityLevel, int score) {

        qDebug() << "\tActivityTypeScoreNode::addScore " << " " <<activityLevel << " " <<score;
        auto levelsNodes = getTreeNodes();
        bool found=false;

        foreach (TreeNode * levelNode, levelsNodes)
        {
            ActivityLevelScoreNode* currentLevel = static_cast<ActivityLevelScoreNode*>(const_cast<TreeNode*>(levelNode));

            if(currentLevel->level() ==activityLevel)
            {
                 qDebug() << "level found ";
                currentLevel->addScore(score);
                found=true;
                break;
            }
        }
        if(!found)
        {
            ActivityLevelScoreNode* level = new ActivityLevelScoreNode();
            insertNode(level);
            level->setParentNode(this);
            level->setLevel(activityLevel);
            level->addScore(score);
        }
        return true;
    }

signals:
    void meanScoreChanged(const int meanScore);

private:
    int mMeanScore;
     QString mName;
};

#endif // ACTIVITYTYPESCORENODE_H
