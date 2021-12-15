#ifndef USER_H
#define USER_H


#include <QObject>
#include <QJsonObject>
#include "TreeModel.h"
class User : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString group
               READ group
               WRITE setGroup
               NOTIFY groupChanged)

    Q_PROPERTY(QString name
               READ name
               WRITE setName
               NOTIFY nameChanged)

    Q_PROPERTY(QString image
               READ image
               WRITE setImage
               NOTIFY imageChanged)

    Q_PROPERTY(TreeModel* scores
               READ scores
               NOTIFY scoresChanged)


    explicit User(QObject *parent = 0);
    ~User()
    {
        delete mScores;
    }
    Q_INVOKABLE bool read(const QString &path);
    Q_INVOKABLE bool write();
    Q_INVOKABLE bool addScore(const QString& activityCategory, const QString& activityType, const int activityLevel, int score);

    QString group() { return mGroup; }
    QString name() { return mName; }
    QString image() { return mImage; }
    TreeModel* scores() { return mScores; }

public slots:
    void setGroup(const QString& aGroup) { mGroup = aGroup;}
    void setName(const QString& aName) { mName = aName;}
    void setImage(const QString& aImage) { mImage = aImage;}


signals:
    void groupChanged(const QString& group);
    void nameChanged(const QString& name);
    void imageChanged(const QString& image);

    void error(const QString& msg);

    void scoresChanged(const TreeModel& scores);



private:
    QString mGroup;
    QString mName;
    QString mFilename;
    QString mImage;
    TreeModel* mScores;

    bool readInternal();

};

#endif // USER_H
