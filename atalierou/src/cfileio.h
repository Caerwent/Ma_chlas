#ifndef CFILEIO_H
#define CFILEIO_H
#include <QGuiApplication>


class CFileIO : public QObject {

    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    Q_INVOKABLE void read();
    Q_INVOKABLE void write();

};


#endif // CFILEIO_H
