#include "wifiConf.h"
#include "backController.h"

WifiConf::WifiConf(): QObject()
{

    QProcess process;
    QString p_stdout;
    QString p_stderr;

    process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
    if(!process.waitForFinished())
        qDebug()<<"can not get hotspot name";
    p_stdout = process.readAllStandardOutput();

    if(!p_stdout.isEmpty())
    {
        int pos = p_stdout.lastIndexOf(QChar('\n'));
        setCurrentSsid(p_stdout.left(pos));
        setDisableWifi(false);
    }
    else
    {

        setDisableWifi(true);
        controller = getInstance();
        controller->changeText("WIFI is not available !");

        return;
    }

    //qDebug()<<p_stdout;
    QString hotspot = "Hotspot";
    if(p_stdout.contains(hotspot, Qt::CaseInsensitive))
    {
        //qDebug()<<"hotspot is active";
        enableHot = true;

    }
    else
    {
        enableHot = false;
        setEnableScanButton(true);


        std::thread([&](){

                controller = getInstance();
                QObject::connect(controller,SIGNAL(sendVis(bool, int)),this,SLOT(setKeyboardProp(bool, int)));

                QMutexLocker locker(&mtxWifi);
                controller->disableBack();
                QString tmpStr = controller->getText();
                //backCont->changeText("Wait... Wait ....");
                controller->changeText("Scanning Network.....");
                std::this_thread::sleep_for(std::chrono::milliseconds(1000));

                //qDebug()<<"wifi conf is called";
                QProcess process;
                QString p_stdout;
                QString p_stderr;

                process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
                if(!process.waitForFinished())
                    qDebug()<<"can not get hotspot name";
                p_stdout = process.readAllStandardOutput();
                if(!p_stdout.isEmpty())
                {
                    int pos = p_stdout.lastIndexOf(QChar('\n'));
                    setCurrentSsid(p_stdout.left(pos));
                }
                //qDebug()<<p_stdout;
                QString hotspot = "Hotspot";
                if(p_stdout.contains(hotspot, Qt::CaseInsensitive))
                {
                    //qDebug()<<"hotspot is active";
                    //enableHot = true;

                }
                else
                {
                    //qDebug()<<"station is active";

                    process.start("bash", QStringList()<<"-c"<<"nmcli -f SSID device wifi");
                    if(!process.waitForFinished())
                        qDebug()<<"can not ssid list";
                    p_stdout = process.readAllStandardOutput();
                    //qDebug()<<p_stdout;
                    // QString str = "madam_curie\nhouse\noffice\noffice2";

                    QStringList tmpList = p_stdout.split("\n");
                    //qDebug()<<"tmpList.size "<<tmpList.size();
                    for(int i = 0 ; i < tmpList.size(); i++)
                    {
                        int truncateAt = tmpList[i].size();
                        int j = truncateAt-1;
                        for(; j >= 0; j--)
                        {
                            if(tmpList[i][j] != ' ') // check at() is supported by qt QStringList
                            {
                                break;
                            }
                        }
                        tmpList[i].truncate(j+1);
                    }
                    for(int i = 0; i < tmpList.size(); i++)
                    {
                        if(tmpList[i].size() > 13)
                            tmpList[i].remove(12,(tmpList[i].size()+1));
                        //qDebug()<<"cons "<<tmpList[i];
                    }
                    if(!tmpList.isEmpty())
                        tmpList.removeFirst(); // first is dummy SSID

                    if(!tmpList.isEmpty())
                        tmpList.removeLast(); // last char
                    //ssidNames = tmp;
                    setSsidNames(tmpList);

                    //enableHot = false;
                    if(tmpList.isEmpty())
                    {

                        //QMutexLocker locker(&mtxWifi);

                        //std::thread t([this](){

                       //QMutexLocker locker(&mtxWifi);

                       std::this_thread::sleep_for(std::chrono::milliseconds(3000));

                       QProcess processSingle;
                       processSingle.start("bash", QStringList()<<"-c"<<"nmcli -f SSID device wifi");
                       if(!processSingle.waitForFinished())
                           qDebug()<<"can not ssid list";
                       QString p_stdout = processSingle.readAllStandardOutput();
                       // qDebug()<<p_stdout;
                       // QString str = "madam_curie\nhouse\noffice\noffice2";

                       QStringList tmp = p_stdout.split("\n");
                       for(int i = 0 ; i < tmp.size(); i++)
                       {
                           int truncateAt = tmp[i].size();
                           int j = truncateAt-1;
                           for(; j >= 0; j--)
                           {
                               if(tmp[i][j] != ' ')
                               {
                                   break;
                               }
                           }
                           tmp[i].truncate(j+1);
                       }
            //           for(int i = 0; i < tmp.size(); i++)
            //           {
            //               qDebug()<<tmp[i];
            //           }
                       if(!tmp.isEmpty())
                           tmp.removeFirst(); // first is dummy SSID
                       if(!tmp.isEmpty())
                           tmp.removeLast(); // last char
                       //ssidNames = tmp;
                       setSsidNames(tmp);


                       QProcess process;
                       process.start("bash", QStringList()<<"-c"<<"nmcli -t -f SIGNAL device wifi list");
                       if(!process.waitForFinished())
                           qDebug()<<"can not ssid str list";

                       p_stdout = process.readAllStandardOutput();
                       //qDebug()<<p_stdout;
                       // QString str = "madam_curie\nhouse\noffice\noffice2";

                       QStringList tmpStrList = p_stdout.split("\n");
                       for(int i = 0 ; i < tmpStrList.size(); i++)
                       {

                           int tmpS = tmpStrList[i].toInt();
                           tmpS = tmpS / 10;
                           QString star;
                           for(int k=0; k<tmpS; k++)
                           {
                                  star += "*";
                           }
                           tmpStrList[i] = star;
                           qDebug()<<"from thread " + tmpStrList[i];
                       }
                       if(!tmpStrList.isEmpty())
                       {
                           tmpStrList.removeLast(); // last char
                       }

                           setSsidStr(tmpStrList);

                        //});
                        //t.detach();

            //            QTimer::singleShot(3000,[this](){
            //                QProcess processSingle;
            //                processSingle.start("bash", QStringList()<<"-c"<<"nmcli -f SSID device wifi");
            //                if(!processSingle.waitForFinished())
            //                    qDebug()<<"can not ssid list";
            //                QString p_stdout = processSingle.readAllStandardOutput();
            //               // qDebug()<<p_stdout;
            //                // QString str = "madam_curie\nhouse\noffice\noffice2";

            //                QStringList tmp = p_stdout.split("\n");
            //                for(int i = 0 ; i < tmp.size(); i++)
            //                {
            //                    int truncateAt = tmp[i].size();
            //                    int j = truncateAt-1;
            //                    for(; j >= 0; j--)
            //                    {
            //                        if(tmp[i][j] != ' ')
            //                        {
            //                            break;
            //                        }
            //                    }
            //                    tmp[i].truncate(j+1);
            //                }
            //                for(int i = 0; i < tmp.size(); i++)
            //                {
            //                    qDebug()<<tmp[i];
            //                }
            //                if(!tmp.isEmpty())
            //                    tmp.removeFirst(); // first is dummy SSID
            //                if(!tmp.isEmpty())
            //                    tmp.removeLast(); // last char
            //                //ssidNames = tmp;
            //                setSsidNames(tmp);
            //            });

                    } // end of empty check tmpList

                    process.start("bash", QStringList()<<"-c"<<"nmcli -t -f SIGNAL device wifi list");
                    if(!process.waitForFinished())
                        qDebug()<<"can not ssid str list";

                    p_stdout = process.readAllStandardOutput();
                    //qDebug()<<p_stdout;
                    // QString str = "madam_curie\nhouse\noffice\noffice2";

                    QStringList tmpStrList = p_stdout.split("\n");
                    for(int i = 0 ; i < tmpStrList.size(); i++)
                    {

                        int tmp = tmpStrList[i].toInt();
                        tmp = tmp / 10;
                        QString star;
                        for(int k=0; k<tmp; k++)
                        {
                               star += "*";
                        }
                        tmpStrList[i] = star;
                        qDebug()<<tmpStrList[i];
                    }
                    if(!tmpStrList.isEmpty())
                        tmpStrList.removeLast(); // last char



                    setSsidStr(tmpStrList);
                } // end of else

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
                    setIpAddr(wIp);

                    std::this_thread::sleep_for(std::chrono::milliseconds(1000));
                    //backCont->changeText(tmpStr+ " IP: "+ wIp);
                    if(tmpStr.contains("IP:"))
                    {
                        controller->changeText(tmpStr+wIp);
                    }
                    else
                    {
                        controller->changeText(tmpStr+ " Connected IP: "+ wIp);
                    }
                }
                else
                {
                    controller->changeText(tmpStr);
                }

                controller->enableBack();
        }).detach();
    }
}

WifiConf::~WifiConf()
{
    QMutexLocker locker(&mtxWifi);
}

//setter functions

void WifiConf::setKeyboardProp(bool flag, int width)
{
    // update keyboard visibility flag
    setKeyFlag(flag);
    //update keyboard width for flicking
    setKeyWidth(width);
    //qDebug()<<width;
    return;
}

void WifiConf::setEnableHot(const bool flag)
{
    enableHot = flag;
    emit enableHotChanged();
}

void WifiConf::setEnableStat(const bool stat)
{
    enableStat = stat;
    emit enableStatChanged();
}

void WifiConf::setSsidNames(const QStringList list)
{
    //mtxWifi.lock();
    ssidNames = list;
    emit ssidNamesChanged();
    //mtxWifi.unlock();
}

void WifiConf::setSsidStr(const QStringList ssidStrList)
{
    ssidStr = ssidStrList;
    emit ssidStrChanged();
}

void WifiConf::setHotSpotPassword(const QString pass)
{
    hotSpotPassword = pass;
    emit hotSpotPasswordChanged();
}

void WifiConf::setHotSpotSsid(const QString ssid)
{
    hotSpotSsid = ssid;
    emit hotSpotSsidChanged();
}

void WifiConf::setStationPassword(const QString pass)
{
    stationPassword = pass;
    emit stationPasswordChanged();
}

void WifiConf::setStationSsid(const QString ssid)
{
    stationSsid = ssid;
    emit stationSsidChanged();
}

void WifiConf::setCurrentSsid(const QString ssid)
{
    currentSsid = ssid;
    emit currentSsidChanged();
}

void WifiConf::setKeyFlag(const bool flag)
{
    keyFlag = flag;
    emit keyFlagChanged();
}

void WifiConf::setKeyWidth(const int width)
{
    keyWidth = width;
    emit keyWidthChanged();
}

void WifiConf::setIpAddr(const QString &ip)
{
    //qDebug()<<"setIpAddr";
    //protect undesired ip address.
    //It should be controlled in qml with regex
    if(ip.count(QChar('.')) == 3)
    {
        m_ipAddr = ip;
        emit ipAddrChanged();
    }
}

void WifiConf::setEnableScanButton(const bool val)
{
    enableScanButton = val;
    emit enableScanButtonChanged();
}

void WifiConf::setDisableWifi(const bool val)
{
    disableWifi = val;
    emit disableWifiChanged();
}

//getter functions

bool WifiConf::getEnableHot() const
{
    return enableHot;
}

bool WifiConf::getEnableStat() const
{
    return enableStat;
}

QStringList WifiConf::getSsidNames() const
{
    return ssidNames;
}

QStringList WifiConf::getSsidStr() const
{
    return ssidStr;
}


QString WifiConf::getHotSpotPassword() const
{
    return hotSpotPassword;
}

QString WifiConf::getHotSpotSsid() const
{
    return hotSpotSsid;
}

QString WifiConf::getStationPassword() const
{
    return stationPassword;
}

QString WifiConf::getStationSsid() const
{
    return stationSsid;
}

QString WifiConf::getCurrentSsid() const
{
    return currentSsid;
}

void WifiConf::enableStatMode()
{

        std::thread([this](){


            controller = getInstance();
            if(controller == nullptr)
            {
                qDebug()<<"backCont is null";
            }

            QMutexLocker locker(&mtxWifi);
            controller->disableBack();
            QString tmpStr = controller->getText();
            controller->changeText("Configuring device please wait ....");
            //start device as a station
            QProcess process;
            process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
            if(!process.waitForFinished())
                qDebug()<<"can not get hotspot name";
            QString p_stdout = process.readAllStandardOutput();
            qDebug()<<p_stdout;
            process.start("bash", QStringList()<<"-c"<<"nmcli connection delete id'"+p_stdout+"'");
            if(!process.waitForFinished())
                qDebug()<<"can not delete connection hotspot";
            process.start("bash", QStringList()<<"-c"<<"nmcli r wifi off"); // enable wifi
            if(!process.waitForFinished())
                qDebug()<<"wifi can not off, check wifi hardware is exist";

            process.start("bash", QStringList()<<"-c"<<"nmcli r wifi on"); // enable wifi
            if(!process.waitForFinished())
                qDebug()<<"wifi can not started, check wifi hardware is exist";

            std::this_thread::sleep_for(std::chrono::milliseconds(2000));

            process.start("bash", QStringList()<<"-c"<<"nmcli -f SSID device wifi");
            if(!process.waitForFinished())
                qDebug()<<"can not ssid list";
            p_stdout = process.readAllStandardOutput();
            //qDebug()<<p_stdout;
            // QString str = "madam_curie\nhouse\noffice\noffice2";

            QStringList tmpList = p_stdout.split("\n");
            //qDebug()<<"tmpList.size "<<tmpList.size();
            for(int i = 0 ; i < tmpList.size(); i++)
            {
                int truncateAt = tmpList[i].size();
                int j = truncateAt-1;
                for(; j >= 0; j--)
                {
                    if(tmpList[i][j] != ' ') // check at() is supported by qt QStringList
                    {
                        break;
                    }
                }
                tmpList[i].truncate(j+1);
            }
            for(int i = 0; i < tmpList.size(); i++)
            {
                if(tmpList[i].size() > 13)
                    tmpList[i].remove(12,(tmpList[i].size()+1));
                //qDebug()<<"cons "<<tmpList[i];
            }
            if(!tmpList.isEmpty())
                tmpList.removeFirst(); // first is dummy SSID

            if(!tmpList.isEmpty())
                tmpList.removeLast(); // last char
            //ssidNames = tmp;
            setSsidNames(tmpList);



            if(tmpList.isEmpty())
            {

                    std::this_thread::sleep_for(std::chrono::milliseconds(2000));

                    QProcess processSingle;
                    processSingle.start("bash", QStringList()<<"-c"<<"nmcli -f SSID device wifi");
                    if(!processSingle.waitForFinished())
                        qDebug()<<"can not ssid list";
                    QString p_stdout = processSingle.readAllStandardOutput();
                   // qDebug()<<p_stdout;
                    // QString str = "madam_curie\nhouse\noffice\noffice2";

                    QStringList tmp = p_stdout.split("\n");
                    for(int i = 0 ; i < tmp.size(); i++)
                    {
                        int truncateAt = tmp[i].size();
                        int j = truncateAt-1;
                        for(; j >= 0; j--)
                        {
                            if(tmp[i][j] != ' ')
                            {
                                break;
                            }
                        }
                        tmp[i].truncate(j+1);
                    }
            //                for(int i = 0; i < tmp.size(); i++)
            //                {
            //                    qDebug()<<tmp[i];
            //                }
                    if(!tmp.isEmpty())
                        tmp.removeFirst(); // first is dummy SSID
                    if(!tmp.isEmpty())
                        tmp.removeLast(); // last char
                    //ssidNames = tmp;
                    setSsidNames(tmp);


                    QProcess process;
                    process.start("bash", QStringList()<<"-c"<<"nmcli -t -f SIGNAL device wifi list");
                    if(!process.waitForFinished())
                        qDebug()<<"can not ssid str list";

                    p_stdout = process.readAllStandardOutput();
                    //qDebug()<<p_stdout;
                    // QString str = "madam_curie\nhouse\noffice\noffice2";

                    QStringList tmpStrList = p_stdout.split("\n");
                    for(int i = 0 ; i < tmpStrList.size(); i++)
                    {

                        int tmpS = tmpStrList[i].toInt();
                        tmpS = tmpS / 10;
                        QString star;
                        for(int k=0; k<tmpS; k++)
                        {
                               star += "*";
                        }
                        tmpStrList[i] = star;
                        qDebug()<<"from thread " + tmpStrList[i];
                    }
                    if(!tmpStrList.isEmpty())
                    {
                        tmpStrList.removeLast(); // last char
                    }

                        setSsidStr(tmpStrList);
            }


            process.start("bash", QStringList()<<"-c"<<"nmcli -t -f SIGNAL device wifi list");
            if(!process.waitForFinished())
                qDebug()<<"can not ssid str list";

            p_stdout = process.readAllStandardOutput();
            //qDebug()<<p_stdout;
            // QString str = "madam_curie\nhouse\noffice\noffice2";

            QStringList tmpStrList = p_stdout.split("\n");
            for(int i = 0 ; i < tmpStrList.size(); i++)
            {

                int tmp = tmpStrList[i].toInt();
                tmp = tmp / 10;
                QString star;
                for(int k=0; k<tmp; k++)
                {
                       star += "*";
                }
                tmpStrList[i] = star;
                qDebug()<<tmpStrList[i];
            }
            if(!tmpStrList.isEmpty())
                tmpStrList.removeLast(); // last char

            setSsidStr(tmpStrList);


            emit enableStatChanged();
            setEnableHot(false);
            controller->changeText("WIFI");

            setEnableStat(true);

            controller->enableBack();


        }).detach();


    return;
}


void WifiConf::updateHotspot(QString name, QString pass)
{

    std::thread([&,name,pass,this](){


        QMutexLocker locker(&mtxWifi);
        if(name.isEmpty() || pass.isEmpty())
            return;

        if(controller == nullptr)
        {
            qDebug()<<"backCont is null";
        }

        controller->disableBack();
        QString tmpStr = controller->getText();
        controller->changeText("Configuring device please wait ....");

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
        process.start("bash", QStringList()<<"-c"<<"nmcli dev wifi hotspot ifname wlan0 ssid '"+name+"' password '"+pass+"'");
        if(process.waitForFinished())
            qDebug()<<"can not start hotspot "+name;

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
            setIpAddr(wIp);

            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
            //backCont->changeText(tmpStr+ " IP: "+ wIp);
            controller->changeText(" Hotspot Tempo IP: "+ wIp);

        }
        else
        {
            controller->changeText(tmpStr);
        }

        setEnableHot(true);

        controller->enableBack();

    }).detach();


//    QTimer::singleShot(3000,[&,name,pass](){
//        QProcess process;
//        process.start("bash", QStringList()<<"-c"<<"nmcli dev wifi hotspot ifname wlan0 ssid '"+name+"' password '"+pass+"'");
//        if(process.waitForFinished())
//            qDebug()<<"can not start hotspot "+name;
//    });
}


void WifiConf::connectToNetwork(QString name, QString pass)
{



    if(name.isEmpty())
        return;

    std::thread([&,name,pass](){

            QMutexLocker locker(&mtxWifi);
            controller->disableBack();
            QString tmpStr = controller->getText();
            controller->changeText("Connecting...");

            std::this_thread::sleep_for(std::chrono::milliseconds(1000));

            //qDebug()<<"connect name "<<name<<" pass "<<pass;
            //qDebug()<<name.length();
            QProcess process;
            QString p_stdout;
            QString out;

            process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
            if(!process.waitForFinished())
                qDebug()<<"can not get hotspot name";
            p_stdout = process.readAllStandardOutput();
            qDebug()<<p_stdout;

            int lastSlash = p_stdout.lastIndexOf("\n");
            //prevSpace = p_stdout.lastIndexOf(' ');
            out = p_stdout.mid(0, lastSlash);
            if(out.contains("\n"))
                out = "";


            //"nmcli d wifi connect '"+name+"' password '"+pass+"' > /dev/null 2>&1 ; echo $?"
            process.start("bash", QStringList()<<"-c"<<"nmcli d wifi connect '"+name+"' password '"+pass+"'");


            if(!process.waitForFinished())
            {
                //qDebug()<<"can not connect "+name;


                controller->changeText("Can not connect. Check router status.");
                std::this_thread::sleep_for(std::chrono::milliseconds(1500));
                controller->changeText(tmpStr);
                std::this_thread::sleep_for(std::chrono::milliseconds(1500));
                controller->enableBack();
                return;
            }
            // do not execute any command here
            int result = process.exitCode();
            //qDebug()<<result;
            if(result != 0)
            {
                //qDebug()<<"can not connect "+name;


                controller->changeText("Not able to connect. Check router status or password.");
                std::this_thread::sleep_for(std::chrono::milliseconds(5000));
                controller->changeText(tmpStr);
                controller->enableBack();
                return;
            }


            QString cmd = "nmcli connection delete id "+out;
            process.start("bash", QStringList()<<"-c"<<cmd);
            if(!process.waitForFinished())
                qDebug()<<"old wifi can not deleted, check wifi hardware is exist";

            setCurrentSsid(name);
            p_stdout = process.readAllStandardOutput();
            //qDebug()<<p_stdout;

            std::this_thread::sleep_for(std::chrono::milliseconds(1000));

            cmd = "nmcli -g ip4.address device show wlan0";
            process.start("bash", QStringList()<<"-c"<<cmd);
            process.waitForFinished();
            p_stdout = process.readAllStandardOutput();
            //qDebug()<<"wif ip addr " + p_stdout;

            lastSlash = p_stdout.lastIndexOf('/');
            //prevSpace = p_stdout.lastIndexOf(' ');
            out = p_stdout.mid(0, lastSlash);
            if(out.contains("\n"))
            {
                out = "";
            }
                if(out.isEmpty())
                {
                    controller->changeText("Not able to connect. Check router status or password.");
                    std::this_thread::sleep_for(std::chrono::milliseconds(5000));
                    controller->changeText(tmpStr);
                    controller->enableBack();
                    return;
                }

            QString res = "Connected... IP : "+out;
            controller->changeText(res);
            std::this_thread::sleep_for(std::chrono::milliseconds(2000));

            QString wIp = out;


            std::this_thread::sleep_for(std::chrono::milliseconds(2000));

            if(tmpStr.contains("IP:"))
            {
                controller->changeText(tmpStr+wIp);
            }
            if(tmpStr.contains("."))
            {
                QString tmp = getIpAddr();
                tmpStr.remove(tmp);
                controller->changeText(tmpStr+wIp);
            }
            else
            {
                controller->changeText(tmpStr+ " Connected IP: "+ wIp);
            }

            setIpAddr(wIp);
            controller->enableBack();

        }).detach();


}

void WifiConf::reScan()
{

    std::thread([this](){

            QMutexLocker locker(&mtxWifi);
            setEnableScanButton(false);
            controller->disableBack();
            QString tmpStr = controller->getText();

            controller->changeText("Scanning Network.....");
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));

            //qDebug()<<"reScan network";
            QProcess process;
            QString p_stdout;

            process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
            if(!process.waitForFinished())
                qDebug()<<"can not get hotspot name";
            p_stdout = process.readAllStandardOutput();
            if(!p_stdout.isEmpty())
            {
                int pos = p_stdout.lastIndexOf(QChar('\n'));
                setCurrentSsid(p_stdout.left(pos));
            }

            process.start("bash", QStringList()<<"-c"<<"nmcli -f SSID device wifi");
            if(!process.waitForFinished())
                qDebug()<<"can not ssid list";
            p_stdout = process.readAllStandardOutput();
            //qDebug()<<p_stdout;
            // QString str = "madam_curie\nhouse\noffice\noffice2";

            QStringList tmpList = p_stdout.split("\n");
            //qDebug()<<"tmpList.size "<<tmpList.size();
            for(int i = 0 ; i < tmpList.size(); i++)
            {
                int truncateAt = tmpList[i].size();
                int j = truncateAt-1;
                for(; j >= 0; j--)
                {
                    if(tmpList[i][j] != ' ') // check at() is supported by qt QStringList
                    {
                        break;
                    }
                }
                tmpList[i].truncate(j+1);
            }
            for(int i = 0; i < tmpList.size(); i++)
            {
                if(tmpList[i].size() > 13)
                    tmpList[i].remove(12,(tmpList[i].size()+1));
                //qDebug()<<"cons "<<tmpList[i];
            }
            if(!tmpList.isEmpty())
                tmpList.removeFirst(); // first is dummy SSID

            if(!tmpList.isEmpty())
                tmpList.removeLast(); // last char
            //ssidNames = tmp;
            setSsidNames(tmpList);

            process.start("bash", QStringList()<<"-c"<<"nmcli -t -f SIGNAL device wifi list");
            if(!process.waitForFinished())
                qDebug()<<"can not ssid str list";

            p_stdout = process.readAllStandardOutput();
            //qDebug()<<p_stdout;
            // QString str = "madam_curie\nhouse\noffice\noffice2";

            QStringList tmpStrList = p_stdout.split("\n");
            for(int i = 0 ; i < tmpStrList.size(); i++)
            {

                int tmp = tmpStrList[i].toInt();
                tmp = tmp / 10;
                QString star;
                for(int k=0; k<tmp; k++)
                {
                       star += "*";
                }
                tmpStrList[i] = star;
                qDebug()<<tmpStrList[i];
            }
            if(!tmpStrList.isEmpty())
                tmpStrList.removeLast(); // last char

            std::this_thread::sleep_for(std::chrono::milliseconds(1000));

            setSsidStr(tmpStrList);

            controller->changeText(tmpStr);
            controller->enableBack();
            setEnableScanButton(true);

        }).detach();
}

void WifiConf::dissconnect()
{

    std::thread([&](){

        QMutexLocker locker(&mtxWifi);
        controller->disableBack();
        QString tmpStr = controller->getText();
        controller->changeText("Disconnecting...");

        std::this_thread::sleep_for(std::chrono::milliseconds(2000));

        QProcess process;
        QString p_stdout;
        QString out;

        process.start("bash", QStringList()<<"-c"<<"nmcli -g general.connection device show wlan0"); // get connection name (id)
        if(!process.waitForFinished())
            qDebug()<<"can not get hotspot name";
        p_stdout = process.readAllStandardOutput();
        qDebug()<<p_stdout;

        int lastSlash = p_stdout.lastIndexOf("\n");
        //prevSpace = p_stdout.lastIndexOf(' ');
        out = p_stdout.mid(0, lastSlash);
        if(out.contains("\n"))
            out = "";

        QString cmd = "nmcli connection delete id "+out;
        process.start("bash", QStringList()<<"-c"<<cmd);
        if(!process.waitForFinished())
            qDebug()<<"old wifi can not deleted, check wifi hardware is exist";

        controller->changeText("WIFI Disconnected...");
        std::this_thread::sleep_for(std::chrono::milliseconds(2000));

        controller->changeText("WIFI");
        controller->enableBack();
        setEnableScanButton(true);


    }).detach();
}

bool WifiConf::getKeyFlag() const
{
    return keyFlag;
}

int WifiConf::getKeyWidth() const
{
    return keyWidth;
}

QString WifiConf::getIpAddr() const
{
    return m_ipAddr;
}

bool WifiConf::getEnableScanButton() const
{
    return enableScanButton;
}

bool WifiConf::getDisableWifi() const
{
    return disableWifi;
}
