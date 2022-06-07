#include <QObject>
#include <QDebug>
#include <QProcess>
#include <thread>
#include "admin.h"
#include <QFile>
#include <QFileInfo>
#include <QStringList>
#include <stdlib.h>

Admin::Admin(): QObject()
{

    controller = getInstance();
    QObject::connect(controller,SIGNAL(sendVis(bool, int)),this,SLOT(setKeyboardProp(bool, int)));

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
        qDebug () << fileName<<" exists" << Qt::endl;
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
            stream << "Gina"<<Qt::endl;
            stream << "Atkins"<<Qt::endl;
            stream << "555 256 54 23"<<Qt::endl;
            stream << "gina@gmail.com"<<Qt::endl;
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

    for ( const auto& i : list  )
    {
        qDebug() << i;
    }

    setName(list[0]);
    setSurname(list[1]);
    setPhoneNumber(list[2]);
    setMail(list[3]);

}

void Admin::setKeyboardProp(bool flag, int width)
{
    // update keyboard visibility flag
    setKeyFlag(flag);
    //update keyboard width for flicking
    setKeyWidth(width);

    return;
}

Admin::~Admin()
{

}


void Admin::applyChanges(QString name, QString surname, QString phone, QString mail)
{

        QStringList list;
        list.push_back(name);
        list.push_back(surname);
        list.push_back(phone);
        list.push_back(mail);

        QFile file(path);

        if(QFileInfo::exists(path))
        {

            file.open(QIODevice::ReadWrite | QIODevice::Text);
            QTextStream stream(&file);

            for ( const auto& i : list  )
            {
                stream << i << Qt::endl;
            }

            file.close();
        }
        else
        {
            qDebug()<<"file not exist to write";
        }

        setName(list[0]);
        setSurname(list[1]);
        setPhoneNumber(list[2]);
        setMail(list[3]);

}


void Admin::setName(const QString arg)
{
    m_name = arg;

    emit nameChanged();
}

void Admin::setSurname(const QString surname)
{
    m_surname = surname;
    emit surnameChanged();
}

void Admin::setPhoneNumber(const QString phoneNumber)
{
    m_phoneNumber = phoneNumber;
    emit phoneNumberChanged();
}

void Admin::setMail(const QString mail)
{
    m_mail = mail;
    emit mailChanged();
}

void Admin::setKeyFlag(const bool flag)
{
    keyFlag = flag;
    emit keyFlagChanged();
}

void Admin::setKeyWidth(const int width)
{
    keyWidth = width;
    emit keyWidthChanged();
}


QString Admin::getName() const
{
    return m_name;
}

QString Admin::getSurname() const
{
    return m_surname;
}

QString Admin::getPhoneNumber() const
{
    return m_phoneNumber;
}

QString Admin::getMail() const
{
    return m_mail;
}

bool Admin::getKeyFlag() const
{
    return keyFlag;
}

int Admin::getKeyWidth() const
{
    return keyWidth;
}
