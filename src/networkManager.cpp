#include <QObject>
#include <QDebug>
#include <QProcess>
#include "networkManager.h"

NetworkManager::NetworkManager(): QObject()
{

    controller = getInstance();

    if(!controller)
    {
        return;
    }

    QObject::connect(controller,SIGNAL(sendVis(bool, int)),this,SLOT(setKeyboardProp(bool, int)));

    auto job = [this](){

        controller->disableBack();

        setButtonStatus(false);

        QProcess process;

        process.start("bash", QStringList()<<"-c"<<"nmcli connection show 'Wired connection 1' | grep  -w ipv4.method");
        process.waitForFinished();
        QString p_stdout = process.readAllStandardOutput();
        QString p_stderr = process.readAllStandardError();
        //qDebug()<<p_stdout;
        int lastSlash = p_stdout.lastIndexOf('\n');
        int prevSpace = p_stdout.lastIndexOf(' ');
        QString out = p_stdout.mid(prevSpace+1, lastSlash - prevSpace-1);
        //qDebug()<<out;
        if(out.contains("\n"))
            out = "";

        if(out == "manual")
        {
        setEnableDHCP(true);
        }
        else if(out == "auto")
        {
            setEnableDHCP(false);
        }

        process.start("bash", QStringList()<<"-c"<<"nmcli -g ip4.address connection show 'Wired connection 1'");
        process.waitForFinished();
        p_stdout = process.readAllStandardOutput();
        p_stderr = process.readAllStandardError();

        if(p_stdout.contains("|")) // there can be old ip addresses. Remove them !
        {
            int numberLine = p_stdout.count("|");

            for(int i=0; i < numberLine; i++)
            {
                lastSlash = p_stdout.indexOf('/');
                out = p_stdout.mid(0, lastSlash);

                //delete old ip address even if it is in the same subnet
                process.start("bash", QStringList()<<"-c"<<"ip addr del "+out+"/24 dev eth0");
                bool result = process.waitForFinished();
                if(!result)
                {
                    qDebug()<<"ip addr can not be deleted "<<result;
                }
                p_stdout.remove(0,lastSlash+6);

            }

            lastSlash = p_stdout.lastIndexOf('/');
            out = p_stdout.mid(0, lastSlash);

            if(!out.contains("\n"))
            {
                setIpAddr(out);
            }

        }
        else
        {
            lastSlash = p_stdout.lastIndexOf('/');
            out = p_stdout.mid(0, lastSlash);

            if(!out.contains("\n"))
            {
                setIpAddr(out);
            }
        }

        process.start("bash", QStringList()<<"-c"<<"nmcli connection show 'Wired connection 1' | grep  -w routers");
        process.waitForFinished();
        p_stdout = process.readAllStandardOutput();
        p_stderr = process.readAllStandardError();

        lastSlash = p_stdout.lastIndexOf('\n');
        prevSpace = p_stdout.lastIndexOf(' ');
        out = p_stdout.mid(prevSpace+1, lastSlash - prevSpace-1);

        if(!out.contains("\n"))
        {
            setRouterAddr(out);
        }

        process.start("bash", QStringList()<<"-c"<<"nmcli connection show 'Wired connection 1' | grep  -w subnet_mask");
        process.waitForFinished();
        p_stdout = process.readAllStandardOutput();
        p_stderr = process.readAllStandardError();

        lastSlash = p_stdout.lastIndexOf('\n');
        prevSpace = p_stdout.lastIndexOf(' ');
        out = p_stdout.mid(prevSpace+1, lastSlash - prevSpace-1);

        if(out.contains("\n"))
            out = "";

        setMaskAddr(out);

        if(!getIpAddr().isEmpty())
        {
            controller->changeText("ETHERNET Connected IP: "+ getIpAddr());
        }

        setButtonStatus(true);
        controller->enableBack();

    };

    handler.addQueue(job);
    handler.processQueue();
}

void NetworkManager::setKeyboardProp(bool flag, int width)
{
    // update keyboard visibility flag
    setKeyFlag(flag);
    //update keyboard width for flicking
    setKeyWidth(width);
    return;
}

NetworkManager::~NetworkManager()
{
    // Wait is there any process in the queue
    while(handler.checkQueueIsEmpty());
}


bool NetworkManager::setIp()
{
    return true;
}

void NetworkManager::setStaticConf(QString ip, QString mask, QString gateway)
{
    ip = "";
    mask = "";
    gateway = "";
}

void NetworkManager::applyNetwork(bool tabBar)
{
    if(tabBar == 0)
    {
        setDHCP();
    }
    else
    {
        setStatic();
    }
}

void NetworkManager::setIpAddr(const QString &ip)
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

void NetworkManager::setEnableDHCP(const bool flag)
{
    //qDebug()<<"setEnableDHCP";
    m_enableDHCP = flag;
    emit enableDHCPChanged();
}

void NetworkManager::setMaskAddr(const QString &mask)
{
    //protect undesired mask address.
    //It should be controlled in qml with regex
    if(mask.count(QChar('.')) == 3)
    {
        m_maskAddr = mask;
        emit maskAddrChanged();
    }
}


void NetworkManager::setRouterAddr(const QString &routerAddr)
{
    //protect undesired routerAddr address.
    //It should be controlled in qml with regex
    if(routerAddr.count(QChar('.')) == 3)
    {
        m_routerAddr = routerAddr;
        emit routerAddrChanged();
    }
}

void NetworkManager::setButtonStatus(const bool stat)
{
    buttonStatus = stat;
    emit buttonStatusChanged();
}

void NetworkManager::setKeyFlag(const bool flag)
{
    keyFlag = flag;
    emit keyFlagChanged();
}

void NetworkManager::setKeyWidth(const int width)
{
    keyWidth = width;
    emit keyWidthChanged();
}

QString NetworkManager::getIpAddr() const
{
    return m_ipAddr;
}

QString NetworkManager::getRouterAddr() const
{
    return m_routerAddr;
}

QString NetworkManager::getMaskAddr() const
{
    return m_maskAddr;
}

bool NetworkManager::getEnableDHCP() const
{
    return m_enableDHCP;
}

bool NetworkManager::getButtonStatus() const
{
    return buttonStatus;
}

bool NetworkManager::setDHCP()
{

    auto job = [this](){

        controller = getInstance();
        controller->disableBack();
        QString tmpStr = controller->getText();
        controller->changeText("Configuring device please wait ....");
       // backCont->enableAnime();
        setButtonStatus(false);

        QProcess process;
        bool result = true;

        QString p_stdout;
        QString p_stderr;

        QString tmpIp = m_ipAddr;


        // set Auto for wired
        process.start("bash", QStringList()<<"-c"<<autoCmd);
        result = process.waitForFinished();

        if(!result)
        {
            qDebug()<<"setDHPC failed "<<result;
            //return result;
        }

        process.start("bash", QStringList()<<"-c"<<upDown);
        process.waitForFinished();
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));

        process.start("bash", QStringList()<<"-c"<<upCon);
        process.waitForFinished();
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));

        //delete old ip address even if it is in the same subnet
        //process.start("bash", QStringList()<<"-c"<<"ip addr del "+tmpIp+"/24 dev eth0");
        //result = process.waitForFinished();
        //if(!result)
        //{
        //    qDebug()<<"ip addr failed "<<result;
        //    //return result;
        //}
        //delete old ip address even if it is in the same subnet

        std::this_thread::sleep_for(std::chrono::milliseconds(500));

        process.start("bash", QStringList()<<"-c"<<"nmcli -g ip4.address connection show 'Wired connection 1'");
        process.waitForFinished();
        p_stdout = process.readAllStandardOutput();
        p_stderr = process.readAllStandardError();
        //qDebug()<<p_stdout;
        //qDebug()<<p_stderr;
        if(p_stdout.contains("|")) // there can be old ip addresses. Remove them !
        {
            int lastSlash;
            int numberLine = p_stdout.count("|");
            //int ipNumber = numberLine + 1;
            for(int i=0; i < numberLine; i++)
            {
                lastSlash = p_stdout.indexOf('/');
                QString out = p_stdout.mid(0, lastSlash);

                //delete old ip address even if it is in the same subnet
                process.start("bash", QStringList()<<"-c"<<"ip addr del "+out+"/24 dev eth0");
                bool result = process.waitForFinished();
                if(!result)
                {
                    qDebug()<<"ip addr can not deleted "<<result;
                }
                p_stdout.remove(0,lastSlash+6);

            }

        }

        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        process.start("bash", QStringList()<<"-c"<<"nmcli -g ip4.address connection show 'Wired connection 1'");
        process.waitForFinished();
        p_stdout = process.readAllStandardOutput();
        p_stderr = process.readAllStandardError();
        //qDebug()<<p_stdout;
        //qDebug()<<p_stderr;
        int lastSlash = p_stdout.lastIndexOf('/');
        int prevSpace = p_stdout.lastIndexOf(' ');
        //qDebug()<<out;
        QString out = p_stdout.mid(0, lastSlash);
        if(out.contains("\n"))
            out = "";

        QString ip = out;
        setIpAddr(ip);

        process.start("bash", QStringList()<<"-c"<<"nmcli connection show 'Wired connection 1' | grep  -w routers");
        process.waitForFinished();
         p_stdout = process.readAllStandardOutput();
         p_stderr = process.readAllStandardError();
        qDebug()<<p_stdout;
        lastSlash = p_stdout.lastIndexOf('\n');
        prevSpace = p_stdout.lastIndexOf(' ');
        out = p_stdout.mid(prevSpace+1, lastSlash - prevSpace-1);
        qDebug()<<out;
        if(out.contains("\n"))
            out = "";

        setRouterAddr(out);

        process.start("bash", QStringList()<<"-c"<<"nmcli connection show 'Wired connection 1' | grep  -w subnet_mask");
        process.waitForFinished();
        p_stdout = process.readAllStandardOutput();
        p_stderr = process.readAllStandardError();
        qDebug()<<p_stdout;
        lastSlash = p_stdout.lastIndexOf('\n');
        prevSpace = p_stdout.lastIndexOf(' ');
        out = p_stdout.mid(prevSpace+1, lastSlash - prevSpace-1);
        qDebug()<<out;
        if(out.contains("\n"))
            out = "";

           setMaskAddr(out);

        setButtonStatus(true);

        //backCont->changeText(tmpStr);
        if(tmpStr.contains("IP:"))
        {
            controller->changeText("ETHERNET Conneccted IP: "+ip);
        }
        if(tmpStr.contains("."))
        {
            QString tmp = getIpAddr();
            tmpStr.remove(tmp);
            controller->changeText(tmpStr+ip);
        }
        else
        {
            controller->changeText(tmpStr+ " Connected IP: "+ ip);
        }
        //backCont->changeText(tmpStr + "IP: "+ getIpAddr());

        controller->enableBack();
    };

    handler.addQueue(job);

    return true;
}

bool NetworkManager::setStatic()
{


    auto job = [this](){

        controller = getInstance();
        controller->disableBack();
        bool result = false;
        QString tmpStr = controller->getText();
        controller->changeText("Configuring device please wait ....");
        setButtonStatus(false);

        QProcess process;

        process.start("bash", QStringList()<<"-c"<<"ip addr del "+m_ipAddr+"/24 dev eth0");
        process.waitForFinished();

        //qDebug()<<"SetStatic function is called";
        // set Manual for wired
        process.start("bash", QStringList()<<"-c"<<staticCmd);
        result = process.waitForFinished();

        if(!result)
        {
            qDebug()<<"setStatıc failed "<<result;
            //return result;
        }

        QString ip = m_ipAddr;
        qDebug()<<ip;
        QString cmd = "nmcli con mod 'Wired connection 1' ipv4.addresses "+ip+"/24";
        process.start("bash", QStringList()<<"-c"<<cmd);
        process.waitForFinished();
        QString p_stdout = process.readAllStandardOutput();
        QString p_stderr = process.readAllStandardError();
        qDebug()<<p_stdout;
        qDebug()<<p_stderr;

        QString gateway = m_routerAddr;
        //qDebug()<<gateway;
        cmd = "nmcli con mod 'Wired connection 1' ipv4.gateway "+gateway;
        process.start("bash", QStringList()<<"-c"<<cmd);
        process.waitForFinished();
        p_stdout = process.readAllStandardOutput();
        p_stderr = process.readAllStandardError();
        //qDebug()<<p_stdout;
        //qDebug()<<p_stderr;

        process.start("bash", QStringList()<<"-c"<<upCon);
        process.waitForFinished();

        setButtonStatus(true);

        //backCont->changeText(tmpStr);
        if(tmpStr.contains("IP:"))
        {
            controller->changeText("ETHERNET Conneccted IP: "+ip);
        }
        if(tmpStr.contains("."))
        {
            QString tmp = getIpAddr();
            tmpStr.remove(tmp);
            controller->changeText(tmpStr+ip);
        }
        else
        {
            controller->changeText(tmpStr+ " Connected IP: "+ ip);
        }

        controller->enableBack();
    };

    handler.addQueue(job);

    return true;
}

bool NetworkManager::getKeyFlag() const
{
    return keyFlag;
}

int NetworkManager::getKeyWidth() const
{
    return keyWidth;
}

