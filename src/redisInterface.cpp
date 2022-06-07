#include "redisInterface.h"

RedisInterface::RedisInterface():updateTime(0)
{


}


RedisInterface::~RedisInterface()
{


}

bool RedisInterface::checkRedisAlive()
{

    QString cmd = "redis-cli ping";
    QProcess process;
    process.start("bash", QStringList()<<"-c"<<cmd);
    process.waitForFinished();
    QString p_stdout = process.readAllStandardOutput();

    if(p_stdout.contains("PONG"))
    {
        qDebug()<<"redis is alive";
        return true;
    }
    else
    {
        qDebug()<<"redis is NOT alive";
        return false;
    }

}

bool RedisInterface::checkRedisIsUpdated()
{
    QString cmd = "redis-cli lastsave";
    QProcess process;
    process.start("bash", QStringList()<<"-c"<<cmd);
    process.waitForFinished();
    QString p_stdout = process.readAllStandardOutput();

    unsigned int lastUpdatedTime = p_stdout.mid(0, p_stdout.lastIndexOf(QChar('\n'))).toInt();
    if(lastUpdatedTime != updateTime)
    {
        //Redis database was updated before
        lastUpdatedTime = updateTime;
        return true;
    }
    return false;
}

bool RedisInterface::setData(QVector<QString> &vec)
{


    bool result = false;

    result = checkRedisAlive();
    if(false == result)
    {
        return result;
    }

    //First add to list , key using first name and second name

    QString str = vec.at(4)// First Name
    +" "+
    vec.at(5)// Last Name
    ;

    addList(str);

    QString cmd = "redis-cli LLEN epilog";
    QProcess process;
    process.start("bash", QStringList()<<"-c"<<cmd);
    result = process.waitForFinished();
    if(!result)
    {
        result = false;
        qDebug()<<Q_FUNC_INFO<<" Can not get length off list";
        return result;
    }

    QString p_stdout = process.readAllStandardOutput();
    QString length = p_stdout.mid(0, p_stdout.lastIndexOf(QChar('\n')));

    int lengthList = length.toInt();

    if(lengthList > 100)
    {
        //need to pop up
        QString cmd = "redis-cli LPOP epilog";
        QProcess process;
        process.start("bash", QStringList()<<"-c"<<cmd);
        result = process.waitForFinished();
        if(!result)
        {
            qDebug()<<Q_FUNC_INFO<<" Can not pop up first element in the list";
        }

        QString p_stdout = process.readAllStandardOutput();
        qDebug()<<p_stdout+" is pop up";

    }

    // create a hash with key ( name and second name )
    //cmd = "redis-cli HMSET ulas:30 user_name ulas age 30";
    cmd = "redis-cli HMSET "+vec.at(4)// First Name
    +":"+vec.at(5)// Second Name
    +" time "+vec.at(0)+
    +" date "+vec.at(1)+
    +" room_temp "+vec.at(2)+
    +" room_hum "+vec.at(3)+
    +" first_name "+vec.at(4)+
    +" second_name "+vec.at(5)+
    +" birth_date "+vec.at(6)+
    +" license_number "+vec.at(7)+
    +" tracking_id "+vec.at(8)+
    +" body_temprature "+vec.at(9)+
    +" reflectivity "+vec.at(10)+
    +" heart_rate "+vec.at(11)+
    +" breathing_rate "+vec.at(12)+
    +" sp02 "+vec.at(13)+
    +" weight "+vec.at(14)+
    +" height "+vec.at(15)+
    +" age "+vec.at(16)+
    +" sex "+vec.at(17)+
    +" race "+vec.at(18)+
    +" mood "+vec.at(19)+
    +" pose "+vec.at(20)+
    +" clothing "+vec.at(21)+
    +" face "+vec.at(22)+
    +" photo "+vec.at(23);

    process.start("bash", QStringList()<<"-c"<<cmd);
    process.waitForFinished();
    p_stdout = process.readAllStandardOutput();
    qDebug()<<p_stdout;
    if(p_stdout.contains("OK"))
    {
        qDebug()<<"Hash map is created";
        result = true;
    }
    else
    {
        qDebug()<<p_stdout<<" hash map can not created";
        result = false;
    }

    return result;
}

bool RedisInterface::addList(QString str)
{

    bool result = false;

    QString cmd = "redis-cli RPUSH epilog "+str;
    QProcess process;
    process.start("bash", QStringList()<<"-c"<<cmd);
    result = process.waitForFinished();
    if(!result)
    {
        result = false;
        qDebug()<<Q_FUNC_INFO<<" Can not push to list";
        return result;
    }

    QString p_stdout = process.readAllStandardOutput();
    qDebug()<<p_stdout;

    int exitCode = process.exitCode();

    if(exitCode != 0)
    {
        result = false;
        qDebug()<<Q_FUNC_INFO<<" Can not push to list";
    }
    else
    {
        result = true;
    }
    return result;
}

unsigned int RedisInterface::listLenght()
{
    unsigned int length;

    QString cmd = "redis-cli LLEN epilog";
    QProcess process;
    process.start("bash", QStringList()<<"-c"<<cmd);
    bool result = process.waitForFinished();
    if(!result)
    {
        result = false;
        qDebug()<<Q_FUNC_INFO<<" Can not get length off list";
        return result;
    }

    QString p_stdout = process.readAllStandardOutput();
    QString lengthStr = p_stdout.mid(0, p_stdout.lastIndexOf(QChar('\n')));

    length = lengthStr.toInt();
    qDebug()<<length;
    return length;
}

//setter methods
void RedisInterface::setLength(unsigned int length)
{
    m_lengthOfList = length;
}

void RedisInterface::setTime(QString time)
{
    m_time = time;
}

void RedisInterface::setDate(QString date)
{
    m_date = date;
}

void RedisInterface::setRoomTemp(float temp)
{
    m_roomTemp = temp;
}

void RedisInterface::setRoomHum(float hum)
{
    m_roomHum = hum;
}

void RedisInterface::setFirstName(QString firstName)
{
    m_firstName = firstName;
}

void RedisInterface::setLastName(QString lastName)
{
    m_lastName = lastName;
}

void RedisInterface::setBirthDate(QString birthDate)
{
    m_birthDate = birthDate;
}

void RedisInterface::setLicenseNumber(QString licenNumber)
{
    m_licenseNumber = licenNumber;
}

void RedisInterface::setTrackId(int trackId)
{
    m_trackID = trackId;
}

void RedisInterface::setBodyTemp(float bodyTemp)
{
    m_bodyTemp = bodyTemp;
}

void RedisInterface::setReflectivity(int reflectivity)
{
    m_reflectivity = reflectivity;
}

void RedisInterface::setHeartRate(int heartRate)
{
    m_heartRate = heartRate;
}

void RedisInterface::setSpo02(float spo2)
{
    m_SpO2 = spo2;
}

void RedisInterface::setWeight(int weight)
{
    m_weight = weight;
}

void RedisInterface::setHeight(int height)
{
    m_height = height;
}

void RedisInterface::setAge(int age)
{
    m_age = age;
}

void RedisInterface::setSex(QString sex)
{
    m_sex = sex;
}

void RedisInterface::setRace(QString race)
{
    m_race = race;
}

void RedisInterface::setMood(QString mood)
{
    m_mood = mood;
}

void RedisInterface::setPose(QString pose)
{
    m_pose = pose;
}

void RedisInterface::setClothing(QString clothing)
{
    m_clothing = clothing;
}

void RedisInterface::setFace(QString face)
{
    m_face = face;
}

void RedisInterface::setPhoto(QVector<QVector<m_rgb>> map)
{
    // copy constructor ?
    m_photo = map;
}

//getter methods
unsigned int RedisInterface::getLength() const
{
    return m_lengthOfList;
}

QString RedisInterface::getTime() const
{
    return m_time;
}

QString RedisInterface::getDate() const
{
    return m_date;
}

float RedisInterface::getRoomTemp() const
{
    return m_roomTemp;
}

float RedisInterface::getRoomHum() const
{
    return m_roomHum;
}

QString RedisInterface::getFirstName() const
{
    return m_firstName;
}

QString RedisInterface::getLastName() const
{
    return m_lastName;
}

QString RedisInterface::getBirthDate() const
{
    return m_birthDate;
}

QString RedisInterface::getLicenseNumber() const
{
    return m_licenseNumber;
}

int RedisInterface::getTrackId() const
{
    return m_trackID;
}

float RedisInterface::getBodyTemp() const
{
    return m_bodyTemp;
}

int RedisInterface::getReflectivity() const
{
    return m_reflectivity;
}

int RedisInterface::getHeartRate() const
{
    return m_heartRate;
}

float RedisInterface::getSpo02() const
{
    return m_SpO2;
}

int RedisInterface::getWeight() const
{
    return m_weight;
}

int RedisInterface::getHeight() const
{
    return m_height;
}

int RedisInterface::getAge() const
{
    return m_age;
}

QString RedisInterface::getSex() const
{
    return m_sex;
}

QString RedisInterface::getRace() const
{
    return m_race;
}

QString RedisInterface::getMood() const
{
    return m_mood;
}

QString RedisInterface::getPose() const
{
    return m_pose;
}

QString RedisInterface::getClothing() const
{
    return m_clothing;
}

QString RedisInterface::getFace() const
{
    return m_face;
}

QVector<QVector<RedisInterface::m_rgb>> RedisInterface::getPhoto() const
{
    return m_photo;
}

QList<QString> RedisInterface::listContent() const
{
    QProcess process;
    QString p_stdout;
    process.start("bash", QStringList()<<"-c"<<"redis-cli LRANGE epilog 0 -1 | cut -d \'\"\' -f2");
    if(!process.waitForFinished())
        qDebug()<<"can not LRANGE list";

    p_stdout = process.readAllStandardOutput();
    //qDebug()<<"LIST "<<p_stdout;
    QStringList list = p_stdout.split("\n");

    return list;

}

QList<QString> RedisInterface::hashContent(QString key) const
{
    QProcess process;
    QString p_stdout;
    process.start("bash", QStringList()<<"-c"<<"redis-cli HGETALL "+ key + " | cut -d \"&\" -f2");
    if(!process.waitForFinished())
        qDebug()<<"can not HGETALL hash";

    p_stdout = process.readAllStandardOutput();
    //qDebug()<<"hash "<<p_stdout;
    QStringList list = p_stdout.split("\n");

    return list;
}


