/*
    Wifi menu ıtem class.
    Configure the wifi ssid and password.
    Chooese wifi ssid and connect it.
    Enable disable station mode.
*/

#pragma once
#include <QObject>
#include <QVector>
#include <QString>
#include <QMutex>
#include <QProcess>
#include <QDebug>
#include <QTimer>
#include <thread>
#include <QMutexLocker>
#include "controllerAdaptor.h"

class WifiConf : public QObject, ControllerAdaptor
{

    Q_OBJECT
    public:
    Q_INVOKABLE void updateHotspot(QString name, QString pass);
    Q_INVOKABLE void connectToNetwork(QString name, QString pass);
    Q_INVOKABLE void enableStatMode();
    Q_INVOKABLE void reScan();
    Q_INVOKABLE void dissconnect();

    Q_PROPERTY(bool enableHot READ getEnableHot WRITE setEnableHot NOTIFY enableHotChanged)
    Q_PROPERTY(bool enableStat READ getEnableStat WRITE setEnableStat NOTIFY enableStatChanged)
    Q_PROPERTY(QStringList ssidNames READ getSsidNames WRITE setSsidNames NOTIFY ssidNamesChanged)
    Q_PROPERTY(QStringList ssidStr READ getSsidStr WRITE setSsidStr NOTIFY ssidStrChanged)
    Q_PROPERTY(QString hotSpotPassword READ getHotSpotPassword  WRITE setHotSpotPassword NOTIFY hotSpotPasswordChanged)
    Q_PROPERTY(QString hotSpotSsid READ getHotSpotSsid WRITE setHotSpotSsid NOTIFY hotSpotSsidChanged)
    Q_PROPERTY(QString stationPassword READ getStationPassword  WRITE setStationPassword NOTIFY stationPasswordChanged)
    Q_PROPERTY(QString stationSsid READ getStationSsid WRITE setStationSsid NOTIFY stationSsidChanged)
    Q_PROPERTY(QString currentSsid READ getCurrentSsid WRITE setCurrentSsid NOTIFY currentSsidChanged)
    Q_PROPERTY(QString ipAddr READ getIpAddr WRITE setIpAddr NOTIFY ipAddrChanged)


    // these two property are used for keyboard, keyboard is called in the main screen so
    // for textfields in the menu items, width and exsistence of the keyboard should be handled internally.
    Q_PROPERTY(bool keyFlag READ getKeyFlag WRITE setKeyFlag NOTIFY keyFlagChanged)
    Q_PROPERTY(int keyWidth READ getKeyWidth WRITE setKeyWidth NOTIFY keyWidthChanged)

    Q_PROPERTY(bool enableScanButton READ getEnableScanButton WRITE setEnableScanButton NOTIFY enableScanButtonChanged)
    Q_PROPERTY(bool disableWifi READ getDisableWifi WRITE setDisableWifi NOTIFY disableWifiChanged)

    WifiConf();
    ~WifiConf();

    public slots:
    bool getEnableHot() const;
    bool getEnableStat() const;
    QStringList getSsidNames() const;
    QStringList getSsidStr() const;
    QString getHotSpotPassword() const;
    QString getHotSpotSsid() const;
    QString getStationPassword() const;
    QString getStationSsid() const;
    QString getCurrentSsid() const;
    QString getIpAddr() const;
    bool getEnableScanButton() const;
    bool getDisableWifi() const;

    bool getKeyFlag() const;
    int getKeyWidth() const;

    void setIpAddr(const QString &ip);
    void setKeyboardProp(bool flag, int width);
    void setKeyFlag(bool flag);
    void setKeyWidth(int width);

    void setEnableHot(const bool flag);
    void setEnableStat(const bool stat);
    void setSsidNames(const QStringList list);
    void setSsidStr(const QStringList list);
    void setHotSpotPassword(const QString pass);
    void setHotSpotSsid(const QString ssid);
    void setStationPassword(const QString pass);
    void setStationSsid(const QString ssid);
    void setCurrentSsid(const QString ssid);
    void setEnableScanButton(const bool val);
    void setDisableWifi(const bool val);

    signals:
    void enableHotChanged();
    void enableStatChanged();
    void ssidNamesChanged();
    void ssidStrChanged();
    void hotSpotPasswordChanged();
    void hotSpotSsidChanged();
    void stationPasswordChanged();
    void stationSsidChanged();
    void currentSsidChanged();
    void ipAddrChanged();
    void disableWifiChanged();

    void keyFlagChanged();
    void keyWidthChanged();

    void enableScanButtonChanged();

    private:
    bool enableHot;
    bool enableStat;
    QStringList ssidNames;
    QStringList ssidStr;
    QString hotSpotPassword;
    QString hotSpotSsid;
    QString stationPassword;
    QString stationSsid;
    QString currentSsid;
    QString m_ipAddr;

    bool keyFlag;
    int keyWidth;
    bool enableScanButton;
    bool disableWifi;

    mutable QMutex mtxWifi;
    mutable QMutex mtxSsid;
};
