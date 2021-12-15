#include "user.h"
#include <QFile>
#include <QUrl>
#include <QFileInfo>
#include <QTextStream>
#include <QTranslator>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QException>
#include <QRegExp>
#include <QStandardPaths>
#include <QtDebug>
#include "ActivityCategoryScoreNode.h"
#include "ActivityTypeScoreNode.h"
#include "ActivityLevelScoreNode.h"
#include "ActivityScoreNode.h"

User::User(QObject *parent) : QObject(parent)
{
    mScores = new TreeModel(this);
}

bool User::addScore(const QString& activityCategory, const QString& activityType, const int activityLevel, int score)
{
     qDebug() << "User::addScore " << activityCategory << " "<< activityType << " " <<activityLevel << " " <<score;
    auto activitiesNodes = mScores->getNodes();
    bool found=false;
     bool added=false;
    foreach (TreeNode* activityNode, activitiesNodes)
    {


        ActivityCategoryScoreNode* currentCategory = static_cast<ActivityCategoryScoreNode*>(const_cast<TreeNode*>(activityNode)) ;
        if(currentCategory->name().compare(activityCategory, Qt::CaseInsensitive)==0)
        {
            qDebug() << "category found ";
            found=true;
            added=currentCategory->addScore(activityType, activityLevel, score);
            break;
        }
    }
    if(!found)
    {
        ActivityCategoryScoreNode* currentCategory = new ActivityCategoryScoreNode();
        currentCategory->setName(activityCategory);
        mScores->insertNode(currentCategory);
        added=currentCategory->addScore(activityType, activityLevel, score);
    }
    return added;
}

bool User::read(const QString &path)
{
    if (path.isEmpty()){
        emit error("source is empty");
        return false;
    }
    if (mGroup.isEmpty()){
        emit error("group is empty");
        return false;
    }
    if (mName.isEmpty()){
        emit error("name is empty");
        return false;
    }

    QRegExp regexp = QRegExp("[^a-zA-Z\\d\\s]");
    QString simpleFilename=regexp.removeIn(mGroup).append("_").append(regexp.removeIn(mName)).replace(" ","_").append(".json");

    if(path.startsWith("file://"))
    {
        mFilename = QString(path+simpleFilename);
        QUrl url(mFilename);
        mFilename=url.toLocalFile();
    }
    else
    {
        auto autoPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        if (autoPath.isEmpty())
            qFatal("Cannot determine settings storage location");
        else
            mFilename = QString(autoPath+"/"+simpleFilename);
    }
    QFile file(mFilename);

    if ( file.exists() )
    {
        readInternal();
    } else {
        if(write())
        {
            readInternal();
        }
        else
        {
            return false;
        }
    }
    return true;
}

bool User::readInternal()
{
    qDebug() << "read user session file " << mFilename;
    QFile file(mFilename);
    if(file.open(QIODevice::ReadOnly|QIODevice::Text) )
    {

        QByteArray data = file.readAll();
        file.close();

        QJsonParseError errorPtr;
        QJsonDocument json_doc = QJsonDocument::fromJson(data, &errorPtr);

        if (json_doc.isNull()) {
            qDebug() << "Parse failed " << errorPtr.errorString();
            emit error("Failed to create JSON doc.");
            return false;
        }
        else if (!json_doc.isObject()) {
            emit error("JSON is not an object.");
            return false;
        }
        else
        {
            QJsonObject json_obj = json_doc.object();
            if (json_obj.isEmpty()) {
                emit error("JSON object is empty.");
                return false;
            }
            else
            {
                try {

                    if(json_obj.contains("activities"))
                    {
                        qDebug() << "activities found " ;
                        QJsonArray activities = json_obj["activities"].toArray();
                        foreach (const QJsonValue &  activity, activities)
                        {
                            qDebug() << "activity " << activity.toString();
                            QJsonObject currActivity = activity.toObject();
                            ActivityCategoryScoreNode* activityCategory = new ActivityCategoryScoreNode(nullptr);
                            mScores->insertNode(activityCategory);
                            activityCategory->setName(currActivity.value("category").toString());
                            if(currActivity.contains("types"))
                            {
                                qDebug() << "types found " ;
                                QJsonArray types = currActivity.value("types").toArray();
                                foreach (const QJsonValue & type, types)
                                {
                                    QJsonObject currType = type.toObject();
                                    ActivityTypeScoreNode* activityType = new ActivityTypeScoreNode(nullptr);
                                    activityCategory->insertNode(activityType);
                                    activityType->setName(currType.value("type").toString());
                                    activityType->setParentNode(activityCategory);

                                    if(currType.contains("levels"))
                                    {
                                        qDebug() << "levels found " ;
                                        QJsonArray levels = currType.value("levels").toArray();
                                        foreach (const QJsonValue & level, levels)
                                        {
                                            QJsonObject currLevel = level.toObject();
                                            ActivityLevelScoreNode* activityLevel = new ActivityLevelScoreNode(nullptr);
                                            activityType->insertNode(activityLevel);
                                            activityLevel->setParentNode(activityType);
                                            activityLevel->setLevel(currLevel.value("level").toInt());
                                            if(currLevel.contains("locked"))
                                            {
                                                activityLevel->setLocked(currLevel.value("locked").toBool());
                                            }
                                            if(currLevel.contains("scores"))
                                            {
                                                qDebug() << "scores found " ;
                                                QJsonArray scores = currLevel.value("scores").toArray();
                                                foreach (const QJsonValue & score, scores)
                                                {
                                                    QJsonObject currScore = score.toObject();
                                                    ActivityScoreNode* activityScore = new ActivityScoreNode(nullptr);
                                                    activityLevel->insertNode(activityScore);
                                                    activityScore->setParentNode(activityLevel);
                                                    activityScore->setDate(currScore.value("date").toString());
                                                    activityScore->setScore(currScore.value("score").toInt());
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    return true;

                }  catch (const QException & exp )
                {
                    emit error(QString(exp.what()));
                    return false;
                }

            }
        }
    }
    else
    {
        QFileInfo fileInfo(file);
        QString filename(fileInfo.absoluteFilePath());
        emit error("Unable to open the file "+ filename);
        return false;
    }
}

bool User::write()
{



    QFile file(mFilename);
    qDebug() << "write user session file " << mFilename;
    if(!file.open(QIODevice::WriteOnly)){
        emit error("failed to open save file");
        return false;
    }
    else
    {

        auto activitiesNodes = mScores->getNodes();
        QJsonArray activities;
        foreach (TreeNode* activityNode, activitiesNodes)
        {
            ActivityCategoryScoreNode* currentCategory = static_cast<ActivityCategoryScoreNode*>(const_cast<TreeNode*>(activityNode));
            qDebug() << "write category ";
            auto typesNodes = currentCategory->getTreeNodes();
            QJsonObject json_activity;
            QJsonArray json_types;
            int meanCategoryScore=0;
            foreach (TreeNode* typeNode, typesNodes)
            {
                ActivityTypeScoreNode* currentType = static_cast<ActivityTypeScoreNode*>(const_cast<TreeNode*>(typeNode));
                qDebug() << "write type ";
                auto levelsNodes = currentType->getTreeNodes();
                QJsonObject json_type;
                QJsonArray json_levels;
                int meanTypeScore=0;
                foreach (TreeNode* levelNode, levelsNodes)
                {
                    ActivityLevelScoreNode* currentLevel = static_cast<ActivityLevelScoreNode*>(const_cast<TreeNode*>(levelNode));
                    qDebug() << "write level ";
                    auto scoresNodes = currentLevel->getTreeNodes();
                    QJsonObject json_level;
                    QJsonArray json_scores;
                    int meanLevelScore=0;
                    foreach (TreeNode* scoreNode, scoresNodes)
                    {
                        ActivityScoreNode* currentScore = static_cast<ActivityScoreNode*>(const_cast<TreeNode*>(scoreNode));

                        QJsonObject json_score;
                        meanLevelScore+=currentScore->score();
                        json_score["score"]=currentScore->score();
                        json_score["date"]=currentScore->dateString();
                        json_scores.append(json_score);
                    }
                    json_level["level"]=currentLevel->level();
                    meanLevelScore=meanLevelScore/currentLevel->count();
                    json_level["score"]=meanLevelScore;
                    meanTypeScore+=meanLevelScore;
                    if(currentLevel->locked())
                    {
                        json_level["locked"]=true;
                    }
                    json_level["scores"]=json_scores;
                    json_levels.append(json_level);
                }
                json_type["type"]=currentType->name();
                meanTypeScore=meanTypeScore/currentType->count();
                meanCategoryScore+=meanTypeScore;
                json_type["score"]=meanTypeScore;
                json_type["levels"]=json_levels;
                json_types.append(json_type);
            }
            json_activity["category"]=currentCategory->name();
            meanCategoryScore=meanCategoryScore/currentCategory->count();
            json_activity["score"]=meanCategoryScore;
            json_activity["types"]=json_types;
            activities.append(json_activity);

        }
        QJsonObject json_obj;
        json_obj["group"] = mGroup;
        json_obj["name"] = mName;
        json_obj["activities"] = activities;
        QJsonDocument json_doc(json_obj);
        QString json_string = json_doc.toJson();
        file.write(json_string.toLocal8Bit());
        file.close();
        return true;
    }

}


