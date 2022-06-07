#include <QObject>
#include <QTimer>
#include <QDebug>
#include <QObject>
#include <QAbstractListModel>
#include <QQmlProperty>
#include <QVariant>
#include <QProcess>
#include <thread>
#include <QFile>
#include <QFileInfo>
#include <stdlib.h>
#include <memory>
#include <iostream>
#include <thread>
#include "hotspot.h"
#include "networkManager.h"
#include "wifiConf.h"
#include "backController.h"
#include "local.h"
#include "alarm.h"
#include "admin.h"

//not used currently
class Helper : public QObject
{
public:
    Q_OBJECT
        public slots:

        //void foo2();

        public:

        Helper();
        ~Helper(){};
};
