
#include "ActivityLevelScoreNode.h"
#include "ActivityScoreNode.h"
void ActivityLevelScoreNode::addScore(int score) {
    qDebug() << "\t\tActivityLevelScoreNode::addScore " << " " <<score;
    ActivityScoreNode* newScore = new ActivityScoreNode();
     insertNode(newScore);
    newScore->setParentNode(this);
    newScore->setScore(score);
    newScore->setDate(QDateTime::currentDateTime());

}

