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
    /*   foreach (TreeNode* activityNode, activitiesNodes)
    {


        ActivityCategoryScoreNode* currentCategory = static_cast<ActivityCategoryScoreNode*>(const_cast<TreeNode*>(activityNode)) ;
        if(currentCategory->name().compare(activityCategory, Qt::CaseInsensitive)==0)
        {
            qDebug() << "category found ";
            found=true;
            added=currentCategory->addScore(activityType, activityLevel, score);
            break;
        }
    }*/
    // cat
    ActivityCategoryScoreNode* currentCategory;
    foreach (TreeNode* activityNode, activitiesNodes)
    {


        currentCategory = static_cast<ActivityCategoryScoreNode*>(activityNode) ;
        if(currentCategory->name().compare(activityCategory, Qt::CaseInsensitive)==0)
        {
            found=true;

        }
    }
    if(!found)
    {
        currentCategory = new ActivityCategoryScoreNode(nullptr);
        currentCategory->setName(activityCategory);
        mScores->insertNode(currentCategory);
    }
    found=false;
    // type
    QModelIndex categoryIndex = mScores->getIndexByNode(currentCategory);
    auto typesNodes = currentCategory->getTreeNodes();
    ActivityTypeScoreNode* currentType;
    foreach (TreeNode * typeNode, typesNodes)
    {
        currentType= static_cast<ActivityTypeScoreNode*>(typeNode);

        if(currentType->name().compare(activityType, Qt::CaseInsensitive)==0)
        {
            found=true;
            break;
        }
    }
    if(!found)
    {
        currentType = new ActivityTypeScoreNode(nullptr);
        mScores->insertNode(currentType, categoryIndex);
        currentType->setName(activityType);
    }
    // level
    found=false;
    QModelIndex typeIndex = mScores->getIndexByNode(currentType);
    auto levelsNodes = currentType->getTreeNodes();
    ActivityLevelScoreNode* currentLevel;
    int insertLevelPosition = -1;
    foreach (TreeNode * levelNode, levelsNodes)
    {
        currentLevel= static_cast<ActivityLevelScoreNode*>(levelNode);

        if(currentLevel->level()==activityLevel)
        {
            found=true;
            break;
        } else if(currentLevel->level()<activityLevel)
        {
            insertLevelPosition=currentLevel->pos();
        }
    }
    if(!found)
    {
        currentLevel = new ActivityLevelScoreNode(nullptr);
        mScores->insertNode(currentLevel, typeIndex,insertLevelPosition);
        currentLevel->setLevel(activityLevel);
    }
    QModelIndex levelIndex = mScores->getIndexByNode(currentLevel);
    //score
    ActivityScoreNode* currentScore = new ActivityScoreNode(nullptr);
    mScores->insertNode(currentScore, levelIndex);
    currentScore->setScore(score);
    currentScore->setDate(QDateTime::currentDateTime());


    // recompute mean scores
    qDebug() << "User::addScore recompute mean scores";
    int meanScore = 0;
    auto scoresNodes = currentLevel->getTreeNodes();
    foreach (TreeNode * scoreNode, scoresNodes)
    {
        currentScore= static_cast<ActivityScoreNode*>(scoreNode);
        meanScore+=currentScore->score();
    }
    meanScore=meanScore/currentLevel->count();
    currentLevel->setMeanScore(meanScore);

    levelsNodes = currentType->getTreeNodes();
    meanScore=0;
    foreach (TreeNode * levelNode, levelsNodes)
    {
        currentLevel= static_cast<ActivityLevelScoreNode*>(levelNode);
        meanScore+=currentLevel->meanScore();
    }
    meanScore=meanScore/currentType->count();
    currentType->setMeanScore(meanScore);
    meanScore=0;
    typesNodes = currentCategory->getTreeNodes();
    foreach (TreeNode * typeNode, typesNodes)
    {
        currentType= static_cast<ActivityTypeScoreNode*>(typeNode);
        meanScore+=currentType->meanScore();
    }
    meanScore=meanScore/currentCategory->count();
    currentCategory->setMeanScore(meanScore);

    emit scoresChanged(mScores);

    return true;
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
inline void swap(QJsonValueRef v1, QJsonValueRef v2)
{
    QJsonValue temp(v1);
    v1 = QJsonValue(v2);
    v2 = temp;
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

                    delete mScores;
                    mScores = new TreeModel(this);

                    if(json_obj.contains("activities"))
                    {
                        qDebug() << "activities found " ;
                        QJsonArray activities = json_obj["activities"].toArray();
                        for ( const auto &activity : activities)
                        {

                            QJsonObject currActivity = activity.toObject();
                            ActivityCategoryScoreNode* activityCategory = new ActivityCategoryScoreNode(nullptr);
                            mScores->insertNode(activityCategory);
                            QModelIndex activityIndex = mScores->getIndexByNode(activityCategory);
                            activityCategory->setName(currActivity.value("category").toString());
                            activityCategory->setMeanScore(currActivity.value("score").toInt());
                            qDebug() << "activity " << activityCategory->name();
                            if(currActivity.contains("types"))
                            {
                                qDebug() << "types found " ;
                                QJsonArray types = currActivity.value("types").toArray();
                                for(const auto & type: types)
                                {
                                    QJsonObject currType = type.toObject();
                                    ActivityTypeScoreNode* activityType = new ActivityTypeScoreNode(nullptr);
                                    mScores->insertNode(activityType, activityIndex);
                                    QModelIndex typeIndex = mScores->getIndexByNode(activityType);

                                    //activityCategory->insertNode(activityType);
                                    activityType->setName(currType.value("type").toString());
                                    activityType->setMeanScore(currType.value("score").toInt());
                                    // activityType->setParentNode(activityCategory);
                                    qDebug() << "type " << activityType->name();
                                    if(currType.contains("levels"))
                                    {
                                        qDebug() << "levels found " ;
                                        QJsonArray levels = currType.value("levels").toArray();


                                        std::sort(levels.begin(), levels.end(), [](const QJsonValue &v1, const QJsonValue &v2) {
                                            return v1.toObject()["level"].toInt() < v2.toObject()["level"].toInt();
                                        });

                                        for (const auto & level: levels)
                                        {
                                            QJsonObject currLevel = level.toObject();
                                            ActivityLevelScoreNode* activityLevel = new ActivityLevelScoreNode(nullptr);
                                            mScores->insertNode(activityLevel, typeIndex);
                                            QModelIndex levelIndex = mScores->getIndexByNode(activityLevel);

                                            //activityType->insertNode(activityLevel);
                                            //activityLevel->setParentNode(activityType);
                                            activityLevel->setLevel(currLevel.value("level").toInt());
                                            activityLevel->setName("level");
                                            qDebug() << "level " << activityLevel->level();
                                            if(currLevel.contains("locked"))
                                            {
                                                activityLevel->setLocked(currLevel.value("locked").toBool());
                                            }
                                            activityLevel->setMeanScore(currLevel.value("score").toInt());
                                            if(currLevel.contains("scores"))
                                            {
                                                qDebug() << "scores found " ;
                                                QJsonArray scores = currLevel.value("scores").toArray();
                                                for (const auto & score: scores)
                                                {
                                                    QJsonObject currScore = score.toObject();
                                                    ActivityScoreNode* activityScore = new ActivityScoreNode(nullptr);
                                                    mScores->insertNode(activityScore, levelIndex);

                                                    //activityLevel->insertNode(activityScore);
                                                    //activityScore->setParentNode(activityLevel);
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

                    emit scoresChanged(mScores);
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
    if(!file.open(QIODevice::WriteOnly|QFile::Truncate)){
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
                        qDebug() << "loop on scores ";
                        ActivityScoreNode* currentScore = static_cast<ActivityScoreNode*>(const_cast<TreeNode*>(scoreNode));
qDebug() << "score " << currentScore->score();
qDebug() << "score " << currentScore->date();
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


bool User::exportCSV(QUrl& csvFilename)
{



    QFile file(csvFilename.toLocalFile());
    qDebug() << "write csv file " << csvFilename;


    //stream << value1 << "\t" << value2 << "\n"; // this writes first line with two columns


    if(!file.open(QIODevice::WriteOnly|QFile::Truncate)){
        emit error("failed to open save file");
        return false;
    }
    else
    {
        QTextStream stream(&file);
        stream << tr("group") << ";" << tr("child") <<";"<<tr("category") << ";" <<tr("type") << ";" << tr("level")  << ";" << tr("date") << ";" << tr("score")  << "\n";
        auto activitiesNodes = mScores->getNodes();

        foreach (TreeNode* activityNode, activitiesNodes)
        {
            ActivityCategoryScoreNode* currentCategory = static_cast<ActivityCategoryScoreNode*>(const_cast<TreeNode*>(activityNode));

            auto typesNodes = currentCategory->getTreeNodes();

            foreach (TreeNode* typeNode, typesNodes)
            {
                ActivityTypeScoreNode* currentType = static_cast<ActivityTypeScoreNode*>(const_cast<TreeNode*>(typeNode));

                auto levelsNodes = currentType->getTreeNodes();
                foreach (TreeNode* levelNode, levelsNodes)
                {
                    ActivityLevelScoreNode* currentLevel = static_cast<ActivityLevelScoreNode*>(const_cast<TreeNode*>(levelNode));

                    auto scoresNodes = currentLevel->getTreeNodes();

                    foreach (TreeNode* scoreNode, scoresNodes)
                    {
                        ActivityScoreNode* currentScore = static_cast<ActivityScoreNode*>(const_cast<TreeNode*>(scoreNode));

                        qDebug() << currentScore->date();
                        stream << mGroup << ";" << mName << ";" << currentCategory->name() << ";" << currentType->name() << ";" << currentLevel->level() << ";" << currentScore->dateString() << ";" << currentScore->score() << "\n";
                    }

                }


            }

        }

        file.close();
        return true;
    }

}

