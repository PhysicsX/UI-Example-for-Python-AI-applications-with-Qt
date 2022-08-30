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
#include "networkManager.h"
#include "backController.h"

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
