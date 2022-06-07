/*
    This clsas is used for System configuration
    Temprature and time.
    All data is written to a file for right now
*/


#include <QObject>
#include <QVector>
#include <QString>
#include <QStringList>
#include <QProcess>
#include <QDebug>
#include <QTimer>
#include <thread>

class Local : public QObject
{

    Q_OBJECT
    public:

    Q_INVOKABLE void applyChanges(QString temp, QString distance, QString time, QString date, QString currentId);
    Q_INVOKABLE void shutdown();
    Q_INVOKABLE void reboot();


    Q_PROPERTY(QString temp READ getTemp WRITE setTemp NOTIFY tempChanged)
    Q_PROPERTY(QString distance READ getDistance WRITE setDistance NOTIFY distanceChanged)
    Q_PROPERTY(QString time READ getTime WRITE setTime NOTIFY timeChanged)
    Q_PROPERTY(QString date READ getDate WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QStringList zone READ getZone WRITE setZone NOTIFY zoneChanged)
    Q_PROPERTY(QString currentId READ getCurrentId WRITE setCurrentId NOTIFY currentIdChanged)

    Local();
    ~Local();

    public slots:
        void setTemp(const QString temp);
        void setDistance(const QString dist);
        void setTime(const QString time);
        void setDate(const QString date);
        void setZone(const QStringList zone);
        void setCurrentId(const QString id);

        QString getTemp() const;
        QString getDistance() const;
        QString getTime() const;
        QString getDate() const;
        QStringList getZone() const;
        QString getCurrentId() const;

    signals:
        void tempChanged();
        void distanceChanged();
        void timeChanged();
        void dateChanged();
        void zoneChanged();
        void currentIdChanged();

    private:
        QString fileName = "local.conf";
        QString user;
        QString home = "home";
        QString path;
        QString m_temp;
        QString m_distance;
        QString m_time;
        QString m_date;
        QStringList m_zone;
        QString m_currentId;
};
