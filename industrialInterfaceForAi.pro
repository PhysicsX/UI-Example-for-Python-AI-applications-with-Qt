QT += quick virtualkeyboard

TARGET = industrialInterfaceForAi

CONFIG += c++11
# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/networkManager.cpp \
        src/backController.cpp \
        src/controllerAdaptor.cpp \
        src/helper.cpp \
        src/main.cpp \




# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

INCLUDEPATH += include

HEADERS += \
    include/backController.h \
    include/controllerAdaptor.h \
    include/helper.h \
    include/networkManager.h \
    include/processQueue.h \

DISTFILES += \
    images/APP.png \
    images/ETHERNET.png \
    images/NOTIFICATIONS.png \
    images/SYSTEM.png \
    images/USERS.png \
    images/WIFI.png \
    images/back.png \
    images/index.png \
    images/settings.png \
    qml/Admin.qml \
    qml/Alarm.qml \
    qml/Local.qml \
    qml/Wifi.qml \
    qml/hotspot.qml \
    qml/network.qml \ \
    scripts/ai_ui.service \
    scripts/autologin.sh \
    scripts/buildQt.sh \
    scripts/redisSetup.sh \
    scripts/run.sh \
    scripts/setupDocker.sh \
    scripts/startEbtUi.sh \
    scripts/testRedis.sh \
    scripts/testRedis1000.sh \
    scripts/updateApp.sh

RESOURCES += \
    qmlResource.qrc

