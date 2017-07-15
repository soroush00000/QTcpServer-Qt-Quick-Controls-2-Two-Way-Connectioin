#include "receive.h"
#include <QString>
#include <QTcpSocket>
#include <QDataStream>
#include <QRect>

static inline QByteArray IntToArray(qint32 source);
static inline qint32 ArrayToInt(QByteArray source);


Receive::Receive(QObject *parent) : QObject(parent)
{
    connect(&server,SIGNAL(newConnection()),
            this,SLOT(acceptConnection()));
    server.listen(QHostAddress::Any,9999);


}

void Receive::getText(const QString& in){
    textTemp = in.toUtf8();
    if(socket->state() == QAbstractSocket::ConnectedState)
        writeData(textTemp);
}


QByteArray Receive::callMeFromQml()
{
    return receivedData;
}

void Receive::acceptConnection()
{
    socket = server.nextPendingConnection();

    connect(socket,SIGNAL(readyRead()),
            this,SLOT(startRead()));

}

void Receive::startRead()
{
    while(socket->bytesAvailable())
    {
        receivedData = socket->readAll();
    }
    receivedData.replace(0,4,"");
}

void Receive::writeData(QByteArray data)
{
    socket->write(IntToArray(data.size()));
    socket->write(data);
}



QByteArray IntToArray(qint32 source)
{
    QByteArray temp;
    QDataStream data(&temp, QIODevice::ReadWrite);
    data << source;
    return temp;
}

qint32 ArrayToInt(QByteArray source)
{
    qint32 temp;
    QDataStream data(&source, QIODevice::ReadWrite);
    data >> temp;
    return temp;
}

