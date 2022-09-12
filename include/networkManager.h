/*
    Wired Network configuration menu ıtem class.
    Configure the wired Ip address for static.
    Monitor dhpc ip address subnetmask and gateway
    Configure static and dhcp mode.
*/


#pragma once
#include <QObject>
#include <QTimer>
#include <thread>
#include <QMutex>
#include "controllerAdaptor.h"
#include "processQueue.h"

class NetworkManager : public QObject, ControllerAdaptor
{
    Q_OBJECT

public:
    Q_INVOKABLE void applyNetwork(bool tabBar);
    Q_INVOKABLE void setStaticConf(QString ip, QString mask, QString gateway);

    Q_PROPERTY(QString ipAddr MEMBER m_ipAddr READ getIpAddr WRITE setIpAddr NOTIFY ipAddrChanged)
    Q_PROPERTY(QString routerAddr MEMBER m_routerAddr READ getRouterAddr WRITE setRouterAddr NOTIFY routerAddrChanged)
    Q_PROPERTY(QString maskAddr MEMBER m_maskAddr READ getMaskAddr WRITE setMaskAddr NOTIFY maskAddrChanged)
    Q_PROPERTY(bool enableDHCP MEMBER m_enableDHCP READ getEnableDHCP WRITE setEnableDHCP NOTIFY enableDHCPChanged)

    Q_PROPERTY(bool buttonStatus READ getButtonStatus WRITE setButtonStatus NOTIFY buttonStatusChanged())

    // these two property are used for keyboard, keyboard is called in the main screen so
    // for textfields in the menu items, width and exsistence of the keyboard should be handled internally.
    Q_PROPERTY(bool keyFlag READ getKeyFlag WRITE setKeyFlag NOTIFY keyFlagChanged)
    Q_PROPERTY(int keyWidth READ getKeyWidth WRITE setKeyWidth NOTIFY keyWidthChanged)

    NetworkManager();
    ~NetworkManager();

    public slots:
        void setKeyboardProp(bool flag, int width);

        void setIpAddr(const QString &ip);
        void setRouterAddr(const QString &router);
        void setMaskAddr(const QString &mask);
        void setEnableDHCP(const bool flag);
        void setButtonStatus(const bool stat);

        void setKeyFlag(bool flag);
        void setKeyWidth(int width);

        QString getRouterAddr() const;
        QString getIpAddr() const;
        QString getMaskAddr() const;
        bool getEnableDHCP() const;

        bool getButtonStatus() const;

        bool getKeyFlag() const;
        int getKeyWidth() const;

        public slots:
        bool setIp();
        //bool setRouter();
        bool setDHCP();
        bool setStatic();
    signals:
        void ipAddrChanged();
        void routerAddrChanged();
        void maskAddrChanged();
        void enableDHCPChanged();

        void buttonStatusChanged();

        void keyFlagChanged();
        void keyWidthChanged();

    private:
        QString m_ipAddr;       // wiring ip address
        QString m_routerAddr;   // wiring router address
        QString m_maskAddr;     // wiring mask address
        bool m_enableDHCP;      // flag for dhcp status

        // some commands are written in the cpp. There should ne another class which controls
        // strings for commands
        QString autoCmd = "nmcli con mod 'Wired connection 1' ipv4.method auto";
        QString staticCmd = "nmcli con mod 'Wired connection 1' ipv4.method manual";
        QString modCmd = "nmcli con mod 'Wired connection 1' ipv4.gateway ";
        QString upCon = "nmcli con up 'Wired connection 1'";
        QString upDown = "nmcli con down 'Wired connection 1'";

        bool buttonStatus;

        bool keyFlag;
        int keyWidth;

        queueProcess<std::function<void()>> handler;
};
