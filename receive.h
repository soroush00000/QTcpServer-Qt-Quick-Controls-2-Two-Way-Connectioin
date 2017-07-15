#ifndef RECEIVE_H
#define RECEIVE_H

#include <QObject>
#include <QDebug>
#include <QTcpServer>
#include <QTcpSocket>

class Receive : public QObject
{
    Q_OBJECT

public:
    explicit Receive(QObject *parent = 0);
    void start(QString address, quint16 port);

signals:

public slots:
    void getText(const QString& in);
    QByteArray callMeFromQml();
    void acceptConnection();
    void startRead();
    void writeData(QByteArray data);

public:

private:
    QTcpServer  server;
    QTcpSocket *socket;
    QByteArray textTemp;
    QHash<QTcpSocket*, QByteArray*> buffers;
    QHash<QTcpSocket*, qint32*> sizes;
    QByteArray receivedData;

};

#endif // RECEIVE_H
