#ifndef ACTIVITYLEVELSCORENODE_H
#define ACTIVITYLEVELSCORENODE_H

#include "TreeNode.h"

class ActivityLevelScoreNode : public TreeNode
{
     Q_OBJECT
public:
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(int meanScore READ meanScore NOTIFY meanScoreChanged)
    Q_PROPERTY(int level READ level)
    Q_PROPERTY(bool locked READ locked WRITE setLocked
               NOTIFY lockedChanged)
    explicit ActivityLevelScoreNode(QObject *parent = nullptr) : TreeNode(parent)
    {

    }
    ~ActivityLevelScoreNode() {}

    QVariant display() const Q_DECL_OVERRIDE {
        return QVariant(mName + " "+ QString::number(mLevel)+ " "+QString::number(mMeanScore)+"%");
    }

    QString name() { return mName; }
     int meanScore() { return mMeanScore; }

     void setName(const QString name) { mName = name;}
     void setMeanScore(int score) { mMeanScore = score;}

     int level() { return mLevel; }
     bool locked() { return mLocked; }

     Q_INVOKABLE void addScore(int score);

     void setLevel(const int level) { mLevel = level;}

signals:
    void lockedChanged(const int locked);
    void meanScoreChanged(const int meanScore);

public slots:
    void setLocked(const bool aLocked) { mLocked = aLocked;}

private:
    int mLevel=0;
    bool mLocked=false;
    int mMeanScore;
     QString mName;
};

#endif // ACTIVITYLEVELSCORENODE_H
