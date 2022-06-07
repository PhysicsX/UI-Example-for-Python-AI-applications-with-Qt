/*
    This class is singleton and it is used for notifications, animations
    and back button controlling. There should be single pointer for all
    menu items to access and configure or change whatever they need.
*/

#pragma once
#include <QObject>
#include <QVector>
#include <QString>
#include <QProcess>
#include <QDebug>
#include <QTimer>
#include <thread>

// Singleton class for backend controller.
// this class is used by all menu items

class BackController : public QObject
{

    Q_OBJECT
    BackController() {};
    BackController(const BackController&) = delete;
    BackController& operator=(const BackController&) = delete;
    BackController(BackController&&) = delete;
    BackController operator=(BackController&&) = delete;

    signals:
       void sendVis(bool flag, int width);
       void sendCurrentdata(const QString &errorMsg,
                            const int& temp,
                            const int& reflectivity,
                            const int& heartRate,
                            const int& sp02,
                            const int& health,
                            const int& exposure);
    //signals:
       // void enableButton();
        //void disableButton();

    public slots:
            void getVis(bool flag);
    public:
        ~BackController() {};

        QObject* m_backImage;       // pointer to back arrow image in the qml
        QObject* m_texNotification; // pointer to Notification bar object in the qml
        QObject* m_textAnime;       // pointer to text animation for Notification bar object in the qml
        void setBackImage(QObject* it);
        void setItemText(QObject* it);
        void setItemTextAnime(QObject* it);

        public:
            bool enableBack();      // This will disable the back arrow button functionality
            bool disableBack();     // This will enable the back arrow button functionality
            void enableAnime();     // starts the animation for Notifications
            void disableAnime();    // stop the animation for Notifications

            // notification area is single for all classes
            static BackController* instanceFactory();

            //update the text for notification
            //this is used by all menu objects
            void changeText(QString txt);

            //retuns the current text on the notification bar
            QString getText();


};
