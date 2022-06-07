#include <QObject>
#include <QDebug>
#include <QProcess>
#include <thread>
#include <QFile>
#include <QFileInfo>
#include <stdlib.h>
#include "local.h"
#include <unistd.h>
#include <linux/reboot.h>
#include <sys/reboot.h>

Local::Local(): QObject()
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
            stream << "Fahrenheit"<<Qt::endl;
            stream << "Feet"<<Qt::endl;

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

    setTemp(list[0]);
    setDistance(list[1]);

    QProcess process;
    QString p_stdout;
    QString p_stderr;

    process.start("bash", QStringList()<<"-c"<<"timedatectl list-timezones"); // get connection name (id)
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    p_stdout = process.readAllStandardOutput();

    QStringList tmpList = p_stdout.split("\n");
    if(!tmpList.isEmpty())
        tmpList.removeLast(); // last char
//    for(int i = 0 ; i < tmpList.size(); i++)
//    {
//        qDebug()<<tmpList[i];
//    }

    setZone(tmpList);

    process.start("bash", QStringList()<<"-c"<<"cat /etc/timezone"); // get connection name (id)
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    p_stdout = process.readAllStandardOutput();

    int pos = p_stdout.lastIndexOf(QChar('\n'));

    setCurrentId(p_stdout.left(pos));

    //set time
    process.start("bash", QStringList()<<"-c"<<"date +%R"); // get connection name (id)
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    p_stdout = process.readAllStandardOutput();

    pos = p_stdout.lastIndexOf(QChar('\n'));
    setTime(p_stdout.left(pos));


    //set date month year
    process.start("bash", QStringList()<<"-c"<<"date +'%m/%d/%y'"); // get connection name (id)
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    p_stdout = process.readAllStandardOutput();

    pos = p_stdout.lastIndexOf(QChar('\n'));
    setDate(p_stdout.left(pos));
}

Local::~Local()
{

}

void Local::applyChanges(QString temp, QString distance, QString time, QString date, QString zone)
{
    qDebug()<<temp<<" "<<distance<<" "<<time<<" "<<date<<" "<<zone;

    QProcess process;
    QString p_stdout;
    QString p_stderr;

    process.start("bash", QStringList()<<"-c"<<"timedatectl set-timezone "+zone);
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    p_stdout = process.readAllStandardOutput();

    process.start("bash", QStringList()<<"-c"<<"date +%R");
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    p_stdout = process.readAllStandardOutput();

    int pos = p_stdout.lastIndexOf(QChar('\n'));
    setTime(p_stdout.left(pos));

    //set date month year
    process.start("bash", QStringList()<<"-c"<<"date +'%m/%d/%y'");
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    p_stdout = process.readAllStandardOutput();

    pos = p_stdout.lastIndexOf(QChar('\n'));
    setDate(p_stdout.left(pos));


    QFile file(path);

    if(QFileInfo::exists(path))
    {
        file.open(QIODevice::ReadWrite | QIODevice::Text);

            QTextStream stream(&file);
            stream << temp<<Qt::endl;
            stream << distance<<Qt::endl;

        file.close();
    }
    else
    {
        qDebug () << "file does not exists" << Qt::endl;
    }

    setTemp(temp);
    setDistance(distance);
}

void Local::shutdown()
{
    QProcess::startDetached("bash",QStringList()<<"-c"<<"shutdown -h now");
}

void Local::reboot()
{
    QProcess::startDetached("bash",QStringList()<<"-c"<<"reboot");
}

void Local::setTemp(const QString temp)
{
    m_temp = temp;
    emit tempChanged();
}

void Local::setDistance(const QString dist)
{
    m_distance = dist;
    emit distanceChanged();
}

void Local::setTime(const QString time)
{
    m_time = time;
    emit timeChanged();
}

void Local::setDate(const QString date)
{
    m_date = date;
    emit dateChanged();
}

void Local::setZone(const QStringList zone)
{
    m_zone = zone;
    emit zoneChanged();
}

void Local::setCurrentId(const QString id)
{
    m_currentId = id;
        qDebug()<<m_currentId;
    emit currentIdChanged();
}

QString Local::getTemp() const
{
    return m_temp;
}

QString Local::getDistance() const
{
    return m_distance;
}

QString Local::getTime() const
{
    return m_time;
}

QString Local::getDate() const
{
    return m_date;
}

QStringList Local::getZone() const
{
    return m_zone;
}

QString Local::getCurrentId() const
{
    return m_currentId;
}
