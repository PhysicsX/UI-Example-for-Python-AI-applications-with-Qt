#include <QObject>
#include <QDebug>
#include <QProcess>
#include <thread>
#include "alarm.h"
#include <QFile>
#include <QFileInfo>
#include <stdlib.h>

Alarm::Alarm(): QObject()
{

    QStringList list;

    user = getenv("USER");

    if(user == "root")
    {
        path = "/opt/"+fileName;
    }
    else
    {
        path = "/"+home+"/"+user+"/"+fileName;
    }
    //path = "/"+home+"/"+user+"/"+fileName;

    QFile file(path);

    if(QFileInfo::exists(path))
    {
        //qDebug () << fileName<<" exists" << endl;
        file.open(QIODevice::ReadWrite | QIODevice::Text);
        while (!file.atEnd()) {
            QByteArray line = file.readLine();
            QString data = QString(line);
            int lastSlash = data.lastIndexOf("\n");
            QString out = data.mid(0, lastSlash);

            list.push_back(out);
            //qDebug() << "read output - " << line;
        }
        file.close();
    }
    else
    {
        qDebug () << "file does not exists" << Qt::endl;
        file.open(QIODevice::ReadWrite | QIODevice::Text);

            QTextStream stream(&file);
            stream << "true"<<Qt::endl;; // audio
            stream << "false"<<Qt::endl;; // text
            stream << "true"<<Qt::endl;; // mail
            stream << "true"<<Qt::endl;; // ledStatu
            stream << "false"<<Qt::endl;; // flashHigh
            stream << "true"<<Qt::endl;; // flashLow
            file.close();

            file.open(QIODevice::ReadWrite | QIODevice::Text);
            while (!file.atEnd()) {
                QByteArray line = file.readLine();
                QString data = QString(line);
                int lastSlash = data.lastIndexOf("\n");
                QString out = data.mid(0, lastSlash);

                list.push_back(out);
                //qDebug() << "read output - " << line;
            }
        file.close();
    }

//    for ( const auto& i : list  )
//    {
//        qDebug() << i;
//    }

    setAudio(QVariant(list[0]).toBool());
    setText(QVariant(list[1]).toBool());
    setMail(QVariant(list[2]).toBool());
    setLedStatu(QVariant(list[3]).toBool());
    setFlashHigh(QVariant(list[4]).toBool());
    setFlashLow(QVariant(list[5]).toBool());
}


Alarm::~Alarm()
{


}

void Alarm::applyChanges(bool audio, bool text, bool mail, bool ledStatu, bool flashHigh, bool flashLow)
{

    QStringList list;
    list.push_back(QVariant(audio).toString());
    list.push_back(QVariant(text).toString());
    list.push_back(QVariant(mail).toString());
    list.push_back(QVariant(ledStatu).toString());
    list.push_back(QVariant(flashHigh).toString());
    list.push_back(QVariant(flashLow).toString());

    QFile file(path);

    if(QFileInfo::exists(path))
    {

        file.open(QIODevice::ReadWrite | QIODevice::Text);
        QTextStream stream(&file);

        for ( const auto& i : list  )
        {
            stream << i <<Qt::endl;
        }

        file.close();
    }
    else
    {
        qDebug()<<"file not exist to write";
    }

    setAudio(QVariant(list[0]).toBool());
    setText(QVariant(list[1]).toBool());
    setMail(QVariant(list[2]).toBool());
    setLedStatu(QVariant(list[3]).toBool());
    setFlashHigh(QVariant(list[4]).toBool());
    setFlashLow(QVariant(list[5]).toBool());
}


void Alarm::setAudio(const bool arg)
{
    m_audio = arg;
    emit audioChanged();
}

void Alarm::setLedStatu(const bool arg)
{
    m_ledStatu = arg;
    emit ledStatuChanged();
}

void Alarm::setText(const bool arg)
{
    m_text = arg;
    emit textChanged();
}

void Alarm::setMail(const bool arg)
{
    m_mail = arg;
    emit mailChanged();
}

void Alarm::setFlashHigh(const bool arg)
{
    m_flashHigh = arg;
    emit flashHighChanged();
}

void Alarm::setFlashLow(const bool arg)
{
    m_flashLow = arg;
    emit flashLowChanged();
}

bool Alarm::getAudio() const
{
    return m_audio;
}

bool Alarm::getLedStatu() const
{
    return m_ledStatu;
}

bool Alarm::getText() const
{
    return m_text;
}

bool Alarm::getMail() const
{
    return m_mail;
}

bool Alarm::getFlashHigh() const
{
    return m_flashHigh;
}

bool Alarm::getFlashLow() const
{
    return m_flashLow;
}
