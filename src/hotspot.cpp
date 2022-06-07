#include "hotspot.h"
#include "backController.h"

Hotspot::Hotspot()
{


    std::thread([&](){


        QMutexLocker locker(&mtxHotspot);
        controller = getInstance();
        controller->disableBack();
        QString tmpStr = controller->getText();
        controller->changeText("Database is loading ....");

        setLengthOfList(0);

        QStringList tmp = listContent();

        // how to check empty hashs
        // for each element in the list there MUST be a hash table according to the name:surname:age


            for(int i=tmp.size()-1; i>=0; i--)
            {

                QStringList tmpList = hashContent(tmp[i]);

                if(tmpList.size() != 53 )
                {
                    qDebug()<<"data is missing ";
                    qDebug()<<tmpList.size();
                    continue;
                }

                time.push_back(tmpList[1]);
                date.push_back(tmpList[3]);
                roomTemp.push_back(tmpList[5]);
                roomHum.push_back(tmpList[7]);
                firstName.push_back(tmpList[9]);
                secName.push_back(tmpList[11]);
                birthDate.push_back(tmpList[13]);
                licenseNumber.push_back(tmpList[15]);
                trackingId.push_back(tmpList[17]);
                bodyTemprature.push_back(tmpList[19]);
                reflectivity.push_back(tmpList[21]);
                heartRate.push_back(tmpList[23]);
                breathingRate.push_back(tmpList[25]);
                sp02.push_back(tmpList[27]);
                health.push_back(tmpList[29]);
                exposure.push_back(tmpList[31]);
                weight.push_back(tmpList[33]);
                height.push_back(tmpList[35]);
                age.push_back(tmpList[37]);
                sex.push_back(tmpList[39]);
                race.push_back(tmpList[41]);
                mood.push_back(tmpList[43]);
                pose.push_back(tmpList[45]);
                clothing.push_back(tmpList[47]);
                face.push_back(tmpList[49]);
                photo.push_back(tmpList[51]);

                emit updateChanged();
                std::this_thread::sleep_for(std::chrono::milliseconds(10));
            }

            controller->changeText("Database access is finished ....");
            std::this_thread::sleep_for(std::chrono::milliseconds(2000));
            controller->changeText(tmpStr);
            std::this_thread::sleep_for(std::chrono::milliseconds(20));
            controller->enableBack();
    }).detach();
    //this is for starting python app from UI. It will be removed in the next.
    setDisableWifi(false);
    setEnableHot(false);


    return;

    QProcess process;
    QString p_stdout;
    QString p_stderr;
    QString hotspot = "Hotspot";

    process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    p_stdout = process.readAllStandardOutput();

    if(p_stdout.isEmpty())
    {

        setDisableWifi(true);
        controller = getInstance();
        controller->changeText("WIFI is not available !");

        return;
    }
    else
    {
        setDisableWifi(false);
    }

    if(p_stdout.contains(hotspot, Qt::CaseInsensitive))
    {
        //qDebug()<<"hotspot is active";
        enableHot = true;

    }
    else
    {
        enableHot = false;
    }

    if(enableHot == true)
    {
    std::thread([&](){

        QMutexLocker locker(&mtxHotspot);

        QProcess process;
        QString p_stdout;
        QString p_stderr;

        controller = getInstance();
        QObject::connect(controller,SIGNAL(sendVis(bool, int)),this,SLOT(setKeyboardProp(bool, int)));

        controller->disableBack();
        QString tmpStr = controller->getText();
        //backCont->changeText("Wait... Wait ....");
        controller->changeText("Configuring device please wait ....");
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));


        process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
        if(!process.waitForFinished())
            qDebug()<<"can not get hotspot name";
        p_stdout = process.readAllStandardOutput();
        if(!p_stdout.isEmpty())
        {
            //int pos = p_stdout.lastIndexOf(QChar('\n'));
            //setCurrentSsid(p_stdout.left(pos));
        }
        //qDebug()<<p_stdout;
        QString hotspot = "Hotspot";
        if(p_stdout.contains(hotspot, Qt::CaseInsensitive))
        {
            //qDebug()<<"hotspot is active";
            enableHot = true;

            QString cmd = "nmcli -g ip4.address device show wlan0";
            process.start("bash", QStringList()<<"-c"<<cmd);
            process.waitForFinished();
            p_stdout = process.readAllStandardOutput();
            //qDebug()<<"wif ip addr " + p_stdout;
            if(!p_stdout.isEmpty())
            {
                int lastSlash = p_stdout.lastIndexOf('/');
                //prevSpace = p_stdout.lastIndexOf(' ');
                QString out = p_stdout.mid(0, lastSlash);
                if(out.contains("\n"))
                    out = "";

                QString wIp = out;

                std::this_thread::sleep_for(std::chrono::milliseconds(1000));
                controller->changeText(tmpStr+ " IP: "+ wIp);
            }
            else
            {
                controller->changeText(tmpStr);
            }

        }
        else
        {
            enableHot = false;
        }

        controller->enableBack();

    }).detach();

    }
}

Hotspot::~Hotspot()
{
    QMutexLocker locker(&mtxHotspot);
}

//setter functions

void Hotspot::setKeyboardProp(bool flag, int width)
{
    // update keyboard visibility flag
    setKeyFlag(flag);
    //update keyboard width for flicking
    setKeyWidth(width);
    //qDebug()<<width;
    return;
}


void Hotspot::setEnableHot(const bool flag)
{
    enableHot = flag;
    emit enableHotChanged();
}

void Hotspot::setEnableStat(const bool stat)
{
    enableStat = stat;
    emit enableStatChanged();
}

void Hotspot::setHotSpotPassword(const QString pass)
{
    hotSpotPassword = pass;
    emit hotSpotPasswordChanged();
}

void Hotspot::setHotSpotSsid(const QString ssid)
{
    hotSpotSsid = ssid;
    emit hotSpotSsidChanged();
}

void Hotspot::setLengthOfList(const unsigned int length)
{
    //Need an interface ?
    lengthOfList = length;
    lengthOfList = listLenght();
    emit lengthOfListChanged();
}

void Hotspot::setKeyFlag(const bool flag)
{
    keyFlag = flag;
    emit keyFlagChanged();
}

void Hotspot::setUpdate(const bool val)
{
    update = val;
    emit updateChanged();
}

void Hotspot::setKeyWidth(const int width)
{
    keyWidth = width;
    emit keyWidthChanged();
}

void Hotspot::setDisableWifi(const bool val)
{
    disableWifi = val;
    emit disableWifiChanged();
}

void Hotspot::setTime(const QVector<QString> list)
{
    time = list;
    emit timeChanged();
}

void Hotspot::setDate(const QVector<QString> list)
{
    date = list;
    emit dateChanged();
}

void Hotspot::setRoomTemp(const QVector<QString> vec)
{
    roomTemp = vec;
    emit roomTempChanged();
}

void Hotspot::setRoomHum(const QVector<QString> vec)
{
    roomHum = vec;
    emit roomHumChanged();
}

void Hotspot::setFirstName(const QVector<QString> vec)
{
    firstName = vec;
    emit roomHumChanged();
}

void Hotspot::setSecName(const QVector<QString> vec)
{
    secName = vec;
    emit secNameChanged();
}

void Hotspot::setBirthDate(const QVector<QString> vec)
{
    birthDate = vec;
    emit birthDateChanged();
}

void Hotspot::setLicenseNumber(const QVector<QString> vec)
{
    licenseNumber = vec;
    emit licenseNumberChanged();
}

void Hotspot::setTrackingId(const QVector<QString> vec)
{
    trackingId = vec;
    emit trackingIdChanged();

}
void Hotspot::setBodyTemprature(const QVector<QString> vec)
{
    bodyTemprature = vec;
    emit bodyTempratureChanged();
}

void Hotspot::setReflectivity(const QVector<QString> vec)
{
    reflectivity = vec;
    emit reflectivityChanged();
}

void Hotspot::setHeartRate(const QVector<QString> vec)
{
    heartRate = vec;
    emit heartRateChanged();
}

void Hotspot::setBreathingRate(const QVector<QString> vec)
{
    breathingRate = vec;
    emit breathingRateChanged();
}

void Hotspot::setSp02(const QVector<QString> vec)
{
    sp02 = vec;
    emit sp02Changed();
}

void Hotspot::setHealth(const QVector<QString> vec)
{
    health = vec;
    emit healthChanged();
}

void Hotspot::setExposure(const QVector<QString> vec)
{
    exposure = vec;
    emit exposureChanged();
}

void Hotspot::setWeight(const QVector<QString> vec)
{
    weight = vec;
    emit weightChanged();
}

void Hotspot::setHeight(const QVector<QString> vec)
{
    height = vec;
    emit heightChanged();
}

void Hotspot::setAge(const QVector<QString> vec)
{
    age = vec;
    emit ageChanged();
}

void Hotspot::setSex(const QVector<QString> vec)
{
    sex = vec;
    emit sexChanged();
}

void Hotspot::setRace(const QVector<QString> vec)
{
    race = vec;
    emit raceChanged();
}

void Hotspot::setMood(const QVector<QString> vec)
{
    mood = vec;
    emit moodChanged();
}

void Hotspot::setPose(const QVector<QString> vec)
{
    pose = vec;
    emit poseChanged();
}

void Hotspot::setClothing(const QVector<QString> vec)
{
    clothing = vec;
    emit clothingChanged();
}

void Hotspot::setFace(const QVector<QString> vec)
{
    face = vec;
    emit faceChanged();
}

void Hotspot::setPhoto(const QVector<QString> vec)
{
    photo = vec;
    emit photoChanged();
}

//getter functions ModuleNotFoundError: No module named 'google.cloud'

bool Hotspot::getEnableHot() const
{
    return enableHot;
}

bool Hotspot::getEnableStat() const
{
    return enableStat;
}

QString Hotspot::getHotSpotPassword() const
{
    return hotSpotPassword;
}

QString Hotspot::getHotSpotSsid() const
{
    return hotSpotSsid;
}

unsigned int Hotspot::getLengthOfList() const
{
    return lengthOfList;
}

void Hotspot::updateHotspot(QString name, QString pass)
{

    return;

    //QProcess::startDetached("bash",QStringList()<<"-c"<<"wmctrl -a /home/ebt/epilog/main.py");
    QString cmd = "wmctrl -l | grep -oP 'IR view'";
    QProcess process;
    process.start("bash", QStringList()<<"-c"<<cmd);
    process.waitForFinished();
    QString p_stdout = process.readAllStandardOutput();

    if(p_stdout.isEmpty())
    {
        QProcess::startDetached("bash",QStringList()<<"-c"<<"runuser -l epilog -c 'export DISPLAY=:0 && python3 /home/epilog/ebt/main.py' > /dev/null 2>&1");
    }

    std::thread([&](){

        controller = getInstance();
        QMutexLocker locker(&mtxHotspot);
        controller->disableBack();
        QString tmpStr = controller->getText();


        QString cmd = "wmctrl -l | grep -oP 'IR view'";
        QProcess process;
        process.start("bash", QStringList()<<"-c"<<cmd);
        process.waitForFinished();
        QString p_stdout = process.readAllStandardOutput();

        if(p_stdout.isEmpty())
        {

            for(int i=10; i>=0; i--)
            {
                controller->changeText("Starting the app in "+QString::number(i)+" sec...");
                std::this_thread::sleep_for(std::chrono::milliseconds(3000));
            }

            process.start("bash", QStringList()<<"-c"<<"wmctrl -a 'IR view'");
            process.waitForFinished();

            p_stdout = "";
            int interrupt = 0;
            while(p_stdout.isEmpty())
            {
                process.start("bash", QStringList()<<"-c"<<cmd);
                process.waitForFinished(100);
                p_stdout = process.readAllStandardOutput();
                controller->changeText("Starting ...");
                interrupt ++;
                std::this_thread::sleep_for(std::chrono::milliseconds(500));
                if(interrupt > 20)
                {
                    break;
                }

            }

            process.start("bash", QStringList()<<"-c"<<"wmctrl -a 'IR view'");
            process.waitForFinished();

        }
        else
        {

                controller->changeText("Starting ....");
                std::this_thread::sleep_for(std::chrono::milliseconds(100));
                process.start("bash", QStringList()<<"-c"<<"wmctrl -a 'IR view'");
                process.waitForFinished();

        }



        controller->changeText(tmpStr);
        controller->enableBack();
        setEnableHot(false);


        std::thread([&](){

            QString cmd = "xinput list --id-only 'cywy USB2IIC_CTP_CONTROL'";
            QProcess process;
            process.start("bash", QStringList()<<"-c"<<cmd);
            process.waitForFinished();
            QString p_stdout = process.readAllStandardOutput();
            int lastSlash = p_stdout.indexOf('/');
            p_stdout = p_stdout.mid(0, lastSlash);
            qDebug()<<p_stdout;

            QString number = p_stdout;
            qDebug()<<number;
            cmd = "xinput test "+number;
            p_stdout = "";
            while(p_stdout.isEmpty())
            {
                QProcess process;
                process.start("bash", QStringList()<<"-c"<<cmd);
                process.waitForFinished(100);
                p_stdout = process.readAllStandardOutput();
                qDebug()<<p_stdout;
                process.terminate();

                if(!p_stdout.isEmpty())
                {
                    qDebug()<<"not empty";
                    std::this_thread::sleep_for(std::chrono::milliseconds(100));
                    QProcess::startDetached("bash",QStringList()<<"-c"<<"wmctrl -a EGLFS");
//                    QProcess process;
//                    process.start("bash", QStringList()<<"-c"<<"wmctrl -a 'EGLFS'");
//                    process.waitForFinished();
//                    process.terminate();
                }

                //std::this_thread::sleep_for(std::chrono::milliseconds(100));

            }

/*
            p_stdout = "";

            while(p_stdout.isEmpty())
            {
                process.start("bash", QStringList()<<"-c"<<cmd);
                process.waitForFinished();
                p_stdout = process.readAllStandardOutput();
                std::this_thread::sleep_for(std::chrono::milliseconds(100));

            }
*/
        }).detach();

    }).detach();

    return;

    if(name.isEmpty() || pass.isEmpty())
        return;

    std::thread([&,name,pass](){

        QMutexLocker locker(&mtxHotspot);
        qDebug()<<"I am here";
        controller->disableBack();
        QString tmpStr = controller->getText();
        controller->changeText("Configuring device please wait ....");

        std::this_thread::sleep_for(std::chrono::milliseconds(1000));

        //qDebug()<<"hotspot name "<<name<<" pass "<<pass;
        QProcess process;
        process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
        if(!process.waitForFinished())
            qDebug()<<"can not get hotspot name";
        QString p_stdout = process.readAllStandardOutput();
        //qDebug()<<p_stdout;
        process.start("bash", QStringList()<<"-c"<<"nmcli connection delete id'"+p_stdout+"'");
        if(!process.waitForFinished())
            qDebug()<<"can not delete connection hotspot";

        process.start("bash", QStringList()<<"-c"<<"nmcli r wifi off");
        if(!process.waitForFinished())
            qDebug()<<"can not turn off wifi";
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        process.start("bash", QStringList()<<"-c"<<"nmcli r wifi on");
        if(!process.waitForFinished())
            qDebug()<<"can not start wifi";

        std::this_thread::sleep_for(std::chrono::milliseconds(3000));
        //QProcess process;
        process.start("bash", QStringList()<<"-c"<<"nmcli dev wifi hotspot ifname wlan0 ssid '"+name+"' password '"+pass+"'");
        if(process.waitForFinished())
            qDebug()<<"can not start hotspot "+name;

        //backCont->changeText(tmpStr);

        QString cmd = "nmcli -g ip4.address device show wlan0";
        process.start("bash", QStringList()<<"-c"<<cmd);
        process.waitForFinished();
        p_stdout = process.readAllStandardOutput();
        //qDebug()<<"wif ip addr " + p_stdout;
        if(!p_stdout.isEmpty())
        {
            int lastSlash = p_stdout.lastIndexOf('/');
            //prevSpace = p_stdout.lastIndexOf(' ');
            QString out = p_stdout.mid(0, lastSlash);
            if(out.contains("\n"))
                out = "";

            QString wIp = out;

            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
            if(tmpStr.contains("IP:"))
            {
                controller->changeText("HOTSPOT IP: "+wIp);
            }
            else
            {
                controller->changeText(tmpStr+ " IP: "+ wIp);
            }
        }
        else
        {
            controller->changeText(tmpStr);
        }
        controller->enableBack();
        setEnableHot(true);


    }).detach();


//    QTimer::singleShot(3000,[&,name,pass](){
//        QProcess process;
//        process.start("bash", QStringList()<<"-c"<<"nmcli dev wifi hotspot ifname wlan0 ssid '"+name+"' password '"+pass+"'");
//        if(process.waitForFinished())
//            qDebug()<<"can not start hotspot "+name;
//    });
}

bool Hotspot::getKeyFlag() const
{
    return keyFlag;
}

int Hotspot::getKeyWidth() const
{
    return keyWidth;
}


bool Hotspot::getDisableWifi() const
{
    return disableWifi;
}

bool Hotspot::getUpdate() const
{
    return update;
}


QVector<QString> Hotspot::getTime() const
{
    return time;
}

QVector<QString> Hotspot::getDate() const
{
    return date;
}

QVector<QString> Hotspot::getRoomTemp() const
{
    return roomTemp;
}

QVector<QString> Hotspot::getRoomHum() const
{
    return roomHum;
}

QVector<QString> Hotspot::getFirstName() const
{
    return firstName;
}

QVector<QString> Hotspot::getSecName() const
{
    return secName;
}

QVector<QString> Hotspot::getBirthDate() const
{
    return birthDate;
}

QVector<QString> Hotspot::getLicenseNumber() const
{
    return licenseNumber;
}

QVector<QString> Hotspot::getTrackingId() const
{
    return trackingId;
}

QVector<QString> Hotspot::getBodyTemprature() const
{
    return bodyTemprature;
}

QVector<QString> Hotspot::getReflectivity() const
{
    return reflectivity;
}

QVector<QString> Hotspot::getHeartRate() const
{
    return heartRate;
}

QVector<QString> Hotspot::getBreathingRate() const
{
    return breathingRate;
}

QVector<QString> Hotspot::getSp02() const
{
    return sp02;
}

QVector<QString> Hotspot::getHealth() const
{
    return health;
}

QVector<QString> Hotspot::getExposure() const
{
    return exposure;
}

QVector<QString> Hotspot::getWeight() const
{
    return weight;
}

QVector<QString> Hotspot::getHeight() const
{
    return height;
}

QVector<QString> Hotspot::getAge() const
{
    return age;
}

QVector<QString> Hotspot::getSex() const
{
    return sex;
}

QVector<QString> Hotspot::getRace() const
{
    return race;
}

QVector<QString> Hotspot::getMood() const
{
    return mood;
}

QVector<QString> Hotspot::getPose() const
{
    return pose;
}

QVector<QString> Hotspot::getClothing() const
{
    return clothing;
}

QVector<QString> Hotspot::getFace() const
{
    return face;
}

QVector<QString> Hotspot::getPhoto() const
{
    return photo;
}

