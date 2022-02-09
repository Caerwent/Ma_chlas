#ifndef CORPUSITEM_H
#define CORPUSITEM_H

#include <QObject>
class CorpusItem: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString corpusId
               READ corpusId
               WRITE corpusId
               NOTIFY corpusIdChanged)
    Q_PROPERTY(QString image
               READ image
               WRITE image
               NOTIFY imageChanged)
    Q_PROPERTY(QString sound
               READ sound
               WRITE sound
               NOTIFY soundChanged)
    Q_PROPERTY(int nbSyllabes
               READ nbSyllabes
               WRITE nbSyllabes
               NOTIFY nbSyllabesChanged)

public:
    CorpusItem(QObject *parent = 0): QObject(parent) {}

    QString corpusId() { return mCorpusId; }
    QString image() { return mImage; }
    QString sound() { return mSound; }
    int nbSyllabes() { return mNbSyllabes; }


public slots:
    void corpusId(const QString& corpusId) { mCorpusId = corpusId;}
    void image(const QString& image) { mImage = image;}
    void sound(const QString& sound) { mSound = sound;}
    void nbSyllabes(const int nbSyllabes) { mNbSyllabes =nbSyllabes;}

signals:
    void corpusIdChanged(const QString& corpusId);
    void imageChanged(const QString& image);
    void soundChanged(const QString& sound);
    void nbSyllabesChanged(const int nbSyllabes);

private:
    QString mCorpusId;
    QString mImage;
    QString mSound;
    int mNbSyllabes;

};
#endif // CORPUSITEM_H
