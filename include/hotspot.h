/*
    Hotspot menu ıtem class.
    Configure the hotspot ssid and password
    Enable disable hotspot mode.
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
#include <QList>
#include <QVector>
#include <QQuickPaintedItem>
#include "controllerAdaptor.h"
#include "redisInterface.h"

class Hotspot : public QObject, ControllerAdaptor, RedisInterface
{
    Q_OBJECT
    public:

    Hotspot();
    ~Hotspot();

    Q_INVOKABLE void updateHotspot(QString name, QString pass);

    Q_PROPERTY(bool enableHot READ getEnableHot WRITE setEnableHot NOTIFY enableHotChanged)
    Q_PROPERTY(bool enableStat READ getEnableStat WRITE setEnableStat NOTIFY enableStatChanged)
    Q_PROPERTY(QString hotSpotPassword READ getHotSpotPassword  WRITE setHotSpotPassword NOTIFY hotSpotPasswordChanged)
    Q_PROPERTY(QString hotSpotSsid READ getHotSpotSsid WRITE setHotSpotSsid NOTIFY hotSpotSsidChanged)
    Q_PROPERTY(unsigned int lengthOfList READ getLengthOfList WRITE setLengthOfList NOTIFY lengthOfListChanged)

    Q_PROPERTY(QVector<QString> time READ getTime WRITE setTime NOTIFY timeChanged)
    Q_PROPERTY(QVector<QString> date READ getDate WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QVector<QString> roomTemp READ getRoomTemp WRITE setRoomTemp NOTIFY roomTempChanged)
    Q_PROPERTY(QVector<QString> roomHum READ getRoomHum WRITE setRoomHum NOTIFY roomHumChanged)
    Q_PROPERTY(QVector<QString> firstName READ getFirstName WRITE setFirstName NOTIFY firstNameChanged)
    Q_PROPERTY(QVector<QString> secName READ getSecName WRITE setSecName NOTIFY secNameChanged)
    Q_PROPERTY(QVector<QString> birthDate READ getBirthDate WRITE setBirthDate NOTIFY birthDateChanged)
    Q_PROPERTY(QVector<QString> licenseNumber READ getLicenseNumber WRITE setLicenseNumber NOTIFY licenseNumberChanged)
    Q_PROPERTY(QVector<QString> trackingId READ getTrackingId WRITE setTrackingId NOTIFY trackingIdChanged)
    Q_PROPERTY(QVector<QString> bodyTemprature READ getBodyTemprature WRITE setBodyTemprature NOTIFY bodyTempratureChanged)
    Q_PROPERTY(QVector<QString> reflectivity READ getReflectivity WRITE setReflectivity NOTIFY reflectivityChanged)
    Q_PROPERTY(QVector<QString> heartRate READ getHeartRate WRITE setHeartRate NOTIFY heartRateChanged)
    Q_PROPERTY(QVector<QString> breathingRate READ getBreathingRate WRITE setBreathingRate NOTIFY breathingRateChanged)
    Q_PROPERTY(QVector<QString> sp02 READ getSp02 WRITE setSp02 NOTIFY sp02Changed)
    Q_PROPERTY(QVector<QString> health READ getHealth WRITE setHealth NOTIFY healthChanged)
    Q_PROPERTY(QVector<QString> exposure READ getExposure WRITE setExposure NOTIFY exposureChanged)
    Q_PROPERTY(QVector<QString> weight READ getWeight WRITE setWeight NOTIFY weightChanged)
    Q_PROPERTY(QVector<QString> height READ getHeight WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(QVector<QString> age READ getAge WRITE setAge NOTIFY ageChanged)
    Q_PROPERTY(QVector<QString> sex READ getSex WRITE setSex NOTIFY sexChanged)
    Q_PROPERTY(QVector<QString> race READ getRace WRITE setRace NOTIFY raceChanged)
    Q_PROPERTY(QVector<QString> mood READ getMood WRITE setMood NOTIFY moodChanged)
    Q_PROPERTY(QVector<QString> pose READ getPose WRITE setPose NOTIFY poseChanged)
    Q_PROPERTY(QVector<QString> clothing READ getClothing WRITE setClothing NOTIFY clothingChanged)
    Q_PROPERTY(QVector<QString> face READ getFace WRITE setFace NOTIFY faceChanged)
    Q_PROPERTY(QVector<QString> photo READ getPhoto WRITE setPhoto NOTIFY photoChanged)

    Q_PROPERTY(bool keyFlag READ getKeyFlag WRITE setKeyFlag NOTIFY keyFlagChanged)
    Q_PROPERTY(int keyWidth READ getKeyWidth WRITE setKeyWidth NOTIFY keyWidthChanged)

    Q_PROPERTY(bool disableWifi READ getDisableWifi WRITE setDisableWifi NOTIFY disableWifiChanged)

    Q_PROPERTY(bool update READ getUpdate WRITE setUpdate NOTIFY updateChanged)


    public slots:
    bool getEnableHot() const;
    bool getEnableStat() const;
    QString getHotSpotPassword() const;
    QString getHotSpotSsid() const;
    unsigned int getLengthOfList() const;

    QVector<QString> getTime() const;
    QVector<QString> getDate() const;
    QVector<QString> getRoomTemp() const;
    QVector<QString> getRoomHum() const;
    QVector<QString> getFirstName() const;
    QVector<QString> getSecName() const;
    QVector<QString> getBirthDate() const;
    QVector<QString> getLicenseNumber() const;
    QVector<QString> getTrackingId() const;
    QVector<QString> getBodyTemprature() const;
    QVector<QString> getReflectivity() const;
    QVector<QString> getHeartRate() const;
    QVector<QString> getBreathingRate() const;
    QVector<QString> getSp02() const;
    QVector<QString> getHealth() const;
    QVector<QString> getExposure() const;
    QVector<QString> getWeight() const;
    QVector<QString> getHeight() const;
    QVector<QString> getAge() const;
    QVector<QString> getSex() const;
    QVector<QString> getRace() const;
    QVector<QString> getMood() const;
    QVector<QString> getPose() const;
    QVector<QString> getClothing() const;
    QVector<QString> getFace() const;
    QVector<QString> getPhoto() const;

    bool getKeyFlag() const;
    int getKeyWidth() const;
    bool getDisableWifi() const;
    bool getUpdate() const;

    void setKeyboardProp(bool flag, int width);
    void setKeyFlag(bool flag);
    void setKeyWidth(int width);

    void setEnableHot(const bool flag);
    void setEnableStat(const bool stat);
    void setHotSpotPassword(const QString pass);
    void setHotSpotSsid(const QString ssid);
    void setLengthOfList(const unsigned int length);
    void setDisableWifi(const bool val);
    void setUpdate(const bool val);

    void setTime(const QVector<QString> list);
    void setDate(const QVector<QString> list);
    void setRoomTemp(const QVector<QString> vec);
    void setRoomHum(const QVector<QString> vec);
    void setFirstName(const QVector<QString> vec);
    void setSecName(const QVector<QString> vec);
    void setBirthDate(const QVector<QString> vec);
    void setLicenseNumber(const QVector<QString> vec);
    void setTrackingId(const QVector<QString> vec);
    void setBodyTemprature(const QVector<QString> vec);
    void setReflectivity(const QVector<QString> vec);
    void setHeartRate(const QVector<QString> vec);
    void setBreathingRate(const QVector<QString> vec);
    void setSp02(const QVector<QString> vec);
    void setHealth(const QVector<QString> vec);
    void setExposure(const QVector<QString> vec);
    void setWeight(const QVector<QString> vec);
    void setHeight(const QVector<QString> vec);
    void setAge(const QVector<QString> vec);
    void setSex(const QVector<QString> vec);
    void setRace(const QVector<QString> vec);
    void setMood(const QVector<QString> vec);
    void setPose(const QVector<QString> vec);
    void setClothing(const QVector<QString> vec);
    void setFace(const QVector<QString> vec);
    void setPhoto(const QVector<QString> vec);

    signals:
    void enableHotChanged();
    void enableStatChanged();
    void hotSpotPasswordChanged();
    void hotSpotSsidChanged();
    void disableWifiChanged();
    void lengthOfListChanged();
    void updateChanged();

    void keyFlagChanged();
    void keyWidthChanged();

    void timeChanged();
    void dateChanged();
    void roomTempChanged();
    void roomHumChanged();
    void firstNameChanged();
    void secNameChanged();
    void birthDateChanged();
    void licenseNumberChanged();
    void trackingIdChanged();
    void bodyTempratureChanged();
    void reflectivityChanged();
    void heartRateChanged();
    void breathingRateChanged();
    void sp02Changed();
    void healthChanged();
    void exposureChanged();
    void weightChanged();
    void heightChanged();
    void ageChanged();
    void sexChanged();
    void raceChanged();
    void moodChanged();
    void poseChanged();
    void clothingChanged();
    void faceChanged();
    void photoChanged();

    private:
    bool enableHot;
    bool enableStat;
    QString hotSpotPassword;
    QString hotSpotSsid;
    unsigned int lengthOfList;

    bool keyFlag;
    int keyWidth;
    bool disableWifi;
    bool update;

    QVector<QString> time;
    QVector<QString> date;
    QVector<QString> roomTemp;
    QVector<QString> roomHum;
    QVector<QString> firstName;
    QVector<QString> secName;
    QVector<QString> birthDate;
    QVector<QString> licenseNumber;
    QVector<QString> trackingId;
    QVector<QString> bodyTemprature;
    QVector<QString> reflectivity;
    QVector<QString> heartRate;
    QVector<QString> breathingRate;
    QVector<QString> sp02;
    QVector<QString> health;
    QVector<QString> exposure;
    QVector<QString> weight;
    QVector<QString> height;
    QVector<QString> age;
    QVector<QString> sex;
    QVector<QString> race;
    QVector<QString> mood;
    QVector<QString> pose;
    QVector<QString> clothing;
    QVector<QString> face;
    QVector<QString> photo;

    mutable QMutex mtxHotspot;

};
