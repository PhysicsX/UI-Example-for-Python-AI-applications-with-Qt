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

    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<NetworkManager>("com.ulasdikme.networkManager",1,0,"NetworkManager");

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


    return app.exec();
}
