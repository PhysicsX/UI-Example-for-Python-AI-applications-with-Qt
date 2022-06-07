#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick/QQuickView>
#include <QtQuick/QQuickItem>
#include <QQuickView>
#include <QQuickItem>

#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <stdlib.h>


#include "helper.h"
#define QT_NO_DEBUG_OUTPUT

int main(int argc, char *argv[])
{

    //backend controller, sigleton class,
    //for notifications, animations and general needs
    BackController* backCont = BackController::instanceFactory(); // only one instance BackController

    //backController backCont;
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<NetworkManager>("com.ulasdikme.networkManager",1,0,"NetworkManager");
    qmlRegisterType<WifiConf>("com.ulasdikme.wifiConf",1,0,"WifiConf");
    qmlRegisterType<Admin>("com.ulasdikme.admin",1,0,"Admin");
    qmlRegisterType<Local>("com.ulasdikme.local",1,0,"Local");
    qmlRegisterType<Alarm>("com.ulasdikme.alarm",1,0,"Alarm");
    qmlRegisterType<Hotspot>("com.ulasdikme.hotspot",1,0,"Hotspot");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:///qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);


    QObject* backButton = NULL; // back button on the notification bar
    backButton = engine.rootObjects().at(0)->findChild<QQuickItem*>("backImage");
    if(backButton == NULL)
        qDebug()<<"itemSettings Null";

    backCont->setBackImage(backButton); // pass pointer of the backImage from main qml
                                        // it will be used in the menu objects !

    QObject* TextMenuNotifications = NULL; // for notification text update
    TextMenuNotifications = engine.rootObjects().at(0)->findChild<QQuickItem*>("settingsText");
    if(TextMenuNotifications == NULL)
        qDebug()<<"itemSettingsText Null";

    backCont->setItemText(TextMenuNotifications); // pass notification bar pointer to
                                                  // control the text update

    QObject* textAnime = NULL; // for text animations
    textAnime = engine.rootObjects().at(0)->findChild<QQuickItem*>("settingsText");
    if(textAnime == NULL)
        qDebug()<<"itemSettingsTextAnime Null";

    backCont->setItemText(textAnime); // pass pointer to singleton class to control animation behaviour


    QObject* keyboardVis = NULL;
    keyboardVis = engine.rootObjects().at(0)->findChild<QQuickItem*>("keyVis");
    if(keyboardVis == NULL)
        qDebug()<<"keyboardVis Null";
    QObject::connect(keyboardVis,SIGNAL(sendVis(bool,int)),backCont,SIGNAL(sendVis(bool,int)));


    //start device as a station
    QProcess process;
    process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    QString p_stdout = process.readAllStandardOutput();
    qDebug()<<p_stdout;
    process.start("bash", QStringList()<<"-c"<<"nmcli connection delete id'"+p_stdout+"'");
    if(!process.waitForFinished())
        qDebug()<<"can not delete connection hotspot";
    process.start("bash", QStringList()<<"-c"<<"nmcli r wifi off"); // enable wifi
    if(!process.waitForFinished())
        qDebug()<<"wifi can not off, check wifi hardware is exist";

    process.start("bash", QStringList()<<"-c"<<"nmcli r wifi on"); // enable wifi
    if(!process.waitForFinished())
        qDebug()<<"wifi can not started, check wifi hardware is exist";


    //std::thread t([](){

        //std::this_thread::sleep_for(std::chrono::milliseconds(3000));

        // auto hotspot configuration at startup
        /*
        QProcess process;
        process.start("bash", QStringList()<<"-c"<<"nmcli dev wifi hotspot ifname wlan0 ssid EPILOG_AP password 'epilog2020'");
        if(process.waitForFinished())
            qDebug()<<"Hotspot is created";
        else
            qDebug()<<"Hotspot can not be created";

        process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
        if(!process.waitForFinished())
            qDebug()<<"can not get hotspot name";
        QString p_stdout = process.readAllStandardOutput();
        qDebug()<<p_stdout;
        QString hotspot = "Hotspot";
        if(p_stdout.contains(hotspot, Qt::CaseInsensitive))
        {
            QString cmd = "nmcli con up"+hotspot;
            process.start("bash", QStringList()<<"-c"<<cmd);
            if(!process.waitForFinished())
                qDebug()<<"Hotspot can not bring up";
        }
        else
        {
            qDebug()<<"Hotspot name can not find";
        }
        */

    //});
    //t.detach();


//    QTimer::singleShot(2000,[&](){
//        QProcess process;
//        process.start("bash", QStringList()<<"-c"<<"nmcli dev wifi hotspot ifname wlan0 ssid EPILOG_AP password 'epilog2020'");
//        if(process.waitForFinished())
//            qDebug()<<"Hotspot is created";
//        else
//            qDebug()<<"Hotspot can not be created";

//        process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
//        if(!process.waitForFinished())
//            qDebug()<<"can not get hotspot name";
//        QString p_stdout = process.readAllStandardOutput();
//        qDebug()<<p_stdout;
//        QString hotspot = "Hotspot";
//        if(p_stdout.contains(hotspot, Qt::CaseInsensitive))
//        {
//            QString cmd = "nmcli con up"+hotspot;
//            process.start("bash", QStringList()<<"-c"<<cmd);
//            if(!process.waitForFinished())
//                qDebug()<<"Hotspot can not bring up";
//        }
//        else
//        {
//            qDebug()<<"Hotspot name can not find";
//        }

//    });


    // Create files to store user configurations
    // for admin configuration. This can be also checked in the constructor
    // of the admin.cpp.

    QString user = getenv("USER");
    QString fileName;

    if(user == "root")
    {
        fileName = "/opt/admin.conf";
    }
    else
    {
        fileName  = "/home/"+user+"/admin.conf";
    }

    QFile file(fileName);

    if(QFileInfo::exists(fileName))
    {
            qDebug () << fileName<<" exists" << Qt::endl;
            file.open(QIODevice::ReadWrite | QIODevice::Text);
            QString data =  file.readAll();
            qDebug () << "data in file:" << data << Qt::endl;
            qDebug()<<"file already created"<< Qt::endl;
            file.close();
    }
    else
    {
        qDebug () << "file does not exists" << Qt::endl;
        file.open(QIODevice::ReadWrite | QIODevice::Text);

            QTextStream stream(&file);
            stream << "Gina"<< Qt::endl;
            stream << "Atkins"<< Qt::endl;
            stream << "555 256 54 23"<< Qt::endl;
            stream << "gina@gmail.com"<< Qt::endl;

        file.close();
    }

        if(user == "root")
        {
            fileName = "/opt/notifications.conf";
        }
        else
        {
            fileName = "/home/"+user+"/notifications.conf";
        }

    QFile fileNot(fileName);

    if(QFileInfo::exists(fileName))
    {
            qDebug () << fileName<<" exists" << Qt::endl;
            fileNot.open(QIODevice::ReadWrite | QIODevice::Text);
            QString data =  fileNot.readAll();
            qDebug () << "data in file:" << data << Qt::endl;
            qDebug()<<"file already created"<< Qt::endl;
            fileNot.close();
    }
    else
    {
        qDebug () << "file does not exists" << Qt::endl;
        fileNot.open(QIODevice::ReadWrite | QIODevice::Text);

            QTextStream stream(&fileNot);
            stream << "true"<< Qt::endl; // audio
            stream << "false"<< Qt::endl; // text
            stream << "true"<< Qt::endl; // mail
            stream << "true"<< Qt::endl; // ledStatu
            stream << "false"<< Qt::endl; // flashHigh
            stream << "true"<< Qt::endl; // flashLow

        fileNot.close();
    }

    if(user == "root")
    {
        fileName = "/opt/local.conf";
    }
    else
    {
        fileName = "/home/"+user+"/local.conf";
    }

    QFile fileLoc(fileName);

    if(QFileInfo::exists(fileName))
    {
        qDebug () << fileName<<" exists" << Qt::endl;
        fileLoc.open(QIODevice::ReadWrite | QIODevice::Text);
        QString data =  fileLoc.readAll();
        qDebug () << "data in file:" << data << Qt::endl;
        qDebug()<<"file already created"<< Qt::endl;
        fileLoc.close();
    }
    else
    {
    qDebug () << "file does not exists" << Qt::endl;
    fileLoc.open(QIODevice::ReadWrite | QIODevice::Text);

        QTextStream stream(&fileLoc);
        stream << "Fahrenheit"<< Qt::endl;
        stream << "Feet"<< Qt::endl;

    fileLoc.close();
    }

    QObject* capturedData = NULL;
    capturedData = engine.rootObjects().at(0)->findChild<QQuickItem*>("capturedData");
    if(capturedData == NULL)
        qDebug()<<"capturedData Null";
    QObject::connect(backCont,SIGNAL(sendCurrentdata(const QString,
                                    const int,
                                    const int,
                                    const int,
                                    const int,
                                    const int,
                                    const int)),
                                    capturedData,
                                    SIGNAL(currentDataSignal(const QString,
                                                                const int,
                                                                const int,
                                                                const int,
                                                                const int,
                                                                const int,
                                                                const int)));

    std::thread([&](){
        char const *socket_path = "/tmp/socketEbt";

        struct sockaddr_un addr;
        unsigned char buf[1000];
        int fd,cl,rc;

        if ( (fd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1) {
          qDebug () << "socket error " <<Qt::endl;
          return;
        }
        memset(&addr, 0, sizeof(addr));
        addr.sun_family = AF_UNIX;
        if (*socket_path == '\0') {
          *addr.sun_path = '\0';
          strncpy(addr.sun_path+1, socket_path+1, sizeof(addr.sun_path)-2);
        } else {
          strncpy(addr.sun_path, socket_path, sizeof(addr.sun_path)-1);
          unlink(socket_path);
        }

        if(bind(fd, (struct sockaddr*)&addr, sizeof(addr)) == -1) {
           qDebug () << "bind error " <<Qt::endl;
          return;
        }

        if(listen(fd, 5) == -1) {
          qDebug () << "listen error " <<Qt::endl;
          exit(-1);
        }
        QProcess process;
        process.start("bash", QStringList()<<"-c"<<"chmod 777 /tmp/socketEbt");
        if(!process.waitForFinished())
            qDebug()<<"can not get hotspot name";
        while (true) {
          if ( (cl = accept(fd, NULL, NULL)) == -1) {
            qDebug () << "accept error " <<Qt::endl;
            continue;
          }

          while ( (rc=read(cl,buf,sizeof(buf))) > 0) {
            qDebug()<<Qt::endl;
            qDebug () << "---------------------------- ";
            qDebug () << "read bytes: " << rc <<" "<<buf;
            //qDebug()<<int(buf[0])<<Qt::endl;
            //printf("%d", (char)p[0]);
            int timeLen = int(buf[0]);
            std::string time;
            for(int i=0; i < timeLen; i++)
            {
                time += buf[1+i];
            }
            qDebug()<<QString::fromStdString(time);

            int newPos = time.size()+1;
            int newLen = int(buf[newPos]);
            int dayLen = newLen;
            std::string day;
            for(int i=0; i < dayLen; i++)
            {
                day += buf[1+newPos+i];
            }
            qDebug()<<"day "<<QString::fromStdString(day);

            newPos += 1 + day.size();
            int roomTemp = int(buf[newPos]);
            qDebug()<<"roomTemp "<<roomTemp;


            newPos += 1;
            int roomHum = int(buf[newPos]);
            qDebug()<<"roomHum "<<roomHum;

            newPos += 1;
            int firstNameLen = int(buf[newPos]);
            std::string firstName;
            for(int i=0; i < firstNameLen; i++)
            {
                firstName += buf[1+newPos+i];
            }
            qDebug()<<"firstName "<<QString::fromStdString(firstName);

            newPos += 1 + firstNameLen;
            int secNameLen = int(buf[newPos]);
            std::string secName;
            for(int i=0; i < secNameLen; i++)
            {
                secName += buf[1+newPos+i];
            }
            qDebug()<<"secName "<<QString::fromStdString(secName);

            newPos += 1 + secNameLen;
            int birthDateLen = int(buf[newPos]);
            std::string birthDate;
            for(int i=0; i < birthDateLen; i++)
            {
                birthDate += buf[1+newPos+i];
            }
            qDebug()<<"birthDate "<<QString::fromStdString(birthDate);

            newPos += 1 + birthDateLen;
            int licenseNumberHigh = (unsigned int)(buf[newPos]);

            newPos += 1;
            int licenseNumberlow = (unsigned char)(buf[newPos]);

            int licenseNumber = licenseNumberHigh * 256 + licenseNumberlow;
            qDebug()<<"licenseNumber "<<licenseNumber;

            newPos += 1;
            int trackingIdHigh = (unsigned int)(buf[newPos]);

            newPos += 1;
            int trackingIdlow = (unsigned char)(buf[newPos]);

            int trackingId = trackingIdHigh * 256 + trackingIdlow;
            qDebug()<<"trackingId "<<trackingId;

            newPos += 1;
            int bodyTemprature = (unsigned char)(buf[newPos]);
            qDebug()<<"bodyTemprature "<<bodyTemprature;

            newPos += 1;
            int reflectivirt = (unsigned char)(buf[newPos]);
            qDebug()<<"reflectivirt "<<reflectivirt;

            newPos += 1;
            int heartRate = (unsigned char)(buf[newPos]);
            qDebug()<<"heartRate "<<heartRate;

            newPos += 1;
            int breathingRate = (unsigned char)(buf[newPos]);
            qDebug()<<"breathingRate "<<breathingRate;

            newPos += 1;
            int sp02 = (unsigned char)(buf[newPos]);
            qDebug()<<"sp02 "<<sp02;

            newPos += 1;
            int health = (unsigned char)(buf[newPos]);
            qDebug()<<"health "<<health;

            newPos += 1;
            int exposure = (unsigned char)(buf[newPos]);
            qDebug()<<"exposure "<<exposure;

            newPos += 1;
            int weight = (unsigned char)(buf[newPos]);
            qDebug()<<"weight "<<weight;

            newPos += 1;
            int height = (unsigned char)(buf[newPos]);
            qDebug()<<"height "<<height;

            newPos += 1;
            int age = (unsigned char)(buf[newPos]);
            qDebug()<<"age"<<age;

            newPos += 1;
            int sexLen = int(buf[newPos]);
            std::string sex;
            for(int i=0; i < sexLen; i++)
            {
                sex += buf[1+newPos+i];
            }
            qDebug()<<"sex "<<QString::fromStdString(sex);

            newPos += 1 + sexLen;
            int raceLen = int(buf[newPos]);
            std::string race;
            for(int i=0; i < raceLen; i++)
            {
                race += buf[1+newPos+i];
            }
            qDebug()<<"race "<<QString::fromStdString(race);

            newPos += 1 + raceLen;
            int modeLen = int(buf[newPos]);
            std::string mode;
            for(int i=0; i < modeLen; i++)
            {
                mode += buf[1+newPos+i];
            }
            qDebug()<<"mode "<<QString::fromStdString(mode);

            newPos += 1 + modeLen;
            int poseLen = int(buf[newPos]);
            std::string pose;
            for(int i=0; i < poseLen; i++)
            {
                pose += buf[1+newPos+i];
            }
            qDebug()<<"pose "<<QString::fromStdString(pose);

            newPos += 1 + poseLen;
            int clothingLen = int(buf[newPos]);
            std::string clothing;
            for(int i=0; i < clothingLen; i++)
            {
                clothing += buf[1+newPos+i];
            }
            qDebug()<<"clothing "<<QString::fromStdString(clothing);

            newPos += 1 + clothingLen;
            int faceLen = int(buf[newPos]);
            std::string face;
            for(int i=0; i < faceLen; i++)
            {
                face += buf[1+newPos+i];
            }
            qDebug()<<"face "<<QString::fromStdString(face);


            newPos += 1 + faceLen;
            int photoLen = int(buf[newPos]);
            std::string photo;
            for(int i=0; i < photoLen; i++)
            {
                photo += buf[1+newPos+i];
            }
            qDebug()<<"photo "<<QString::fromStdString(photo);

            memset(buf, 0, sizeof(buf));

            BackController* backCont = BackController::instanceFactory();
            int convertedTemp = 14.29*bodyTemprature-485.28;

            qDebug()<<"convertedTemp "<<convertedTemp;
            int convertedHeartRate = (100*heartRate/185)-(700/37);
            backCont->sendCurrentdata(QString::fromStdString(photo),
                                        convertedTemp,
                                        reflectivirt,
                                        convertedHeartRate,
                                        sp02,
                                        health,
                                        exposure);
          }
          if (rc == -1) {
            qDebug () << "read error " <<Qt::endl;
            return;
          }

        }
    }).detach();
    return app.exec();
}
