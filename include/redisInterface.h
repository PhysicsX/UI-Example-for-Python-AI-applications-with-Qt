#pragma once
#include <QProcess>
#include <QString>
#include <QVector>
#include <QProcess>
#include <QDebug>

class RedisInterface
{


    public:
        RedisInterface();
        ~RedisInterface();

    struct m_rgb
    {
        unsigned char red;
        unsigned char green;
        unsigned char blue;
    };

    bool checkRedisAlive();
    bool checkRedisIsUpdated();
    bool setData(QVector<QString> &vec);
    bool addList(QString str);
    unsigned int listLenght();


    void setLength(unsigned int length);
    void setTime(QString time);
    void setDate(QString date);
    void setRoomTemp(float temp);
    void setRoomHum(float hum);
    void setFirstName(QString firstName);
    void setLastName(QString lastName);
    void setBirthDate(QString birthDate);
    void setLicenseNumber(QString licenNumber);
    void setTrackId(int trackId);
    void setBodyTemp(float bodyTemp);
    void setReflectivity(int reflectivity);
    void setHeartRate(int heartRate);
    void setSpo02(float spo2);
    void setWeight(int weight);
    void setHeight(int height);
    void setAge(int age);
    void setSex(QString sex);
    void setRace(QString race);
    void setMood(QString mood);
    void setPose(QString pose);
    void setClothing(QString clothing);
    void setFace(QString face);
    void setPhoto(QVector<QVector<m_rgb>> map);

    unsigned int getLength() const;
    QString getTime() const;
    QString getDate() const;
    float getRoomTemp() const;
    float getRoomHum() const;
    QString getFirstName() const;
    QString getLastName() const;
    QString getBirthDate() const;
    QString getLicenseNumber() const;
    int getTrackId() const;
    float getBodyTemp() const;
    int getReflectivity() const;
    int getHeartRate() const;
    float getSpo02() const;
    int getWeight() const;
    int getHeight() const;
    int getAge() const;
    QString getSex() const;
    QString getRace() const;
    QString getMood() const;
    QString getPose() const;
    QString getClothing() const;
    QString getFace() const;
    QVector<QVector<m_rgb>> getPhoto() const;

    QList<QString> listContent() const;
    QList<QString> hashContent(QString key) const;


    private:

    QString m_time;
    QString m_date;
    float m_roomTemp;
    float m_roomHum;

    unsigned int m_lengthOfList;

    QString m_firstName;
    QString m_lastName;
    QString m_birthDate;
    QString m_licenseNumber;
    int m_trackID;

    float m_bodyTemp;
    int m_reflectivity;
    int m_heartRate;
    float m_SpO2;
    int m_weight;
    int m_height;
    int m_age;
    QString m_sex;
    QString m_race;
    QString m_mood;
    QString m_pose;
    QString m_clothing;
    QString m_face;


    QVector<QVector<struct m_rgb>> m_photo;

    unsigned int updateTime;

};
