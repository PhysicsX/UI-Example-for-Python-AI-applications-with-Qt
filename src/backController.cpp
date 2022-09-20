#include "backController.h"


bool BackController::enableBack()
{

    std::lock_guard<std::mutex> guard(m);
    //emit enableButton();
    m_backImage->setProperty("enabled",true);

    return true;
}

bool BackController::disableBack()
{
    std::lock_guard<std::mutex> guard(m);
    //emit disableButton();
    m_backImage->setProperty("enabled",false);

    return true;
}

void BackController::setBackImage(QObject* it)
{
    std::lock_guard<std::mutex> guard(m);
    m_backImage = it;
    //item->setProperty("enabled",false);
    return;
}

void BackController::changeText(QString txt)
{
    std::lock_guard<std::mutex> guard(m);
    m_texNotification->setProperty("text",txt);
    return;
}


void BackController::setItemText(QObject* it)
{
    std::lock_guard<std::mutex> guard(m);
    m_texNotification = it;
    //item->setProperty("enabled",false);
    return;
}

void BackController::setItemTextAnime(QObject* it)
{
    std::lock_guard<std::mutex> guard(m);
    m_textAnime = it;
    return;
}

QString BackController::getText()
{
    std::lock_guard<std::mutex> guard(m);
    return m_texNotification->property("text").toString();
}

void BackController::enableAnime()
{
    std::lock_guard<std::mutex> guard(m);
    m_textAnime->setProperty("running",true);
    return;
}

void BackController::disableAnime()
{
    std::lock_guard<std::mutex> guard(m);
    m_textAnime->setProperty("running",false);
    return;
}
void BackController::getVis(bool flag)
{
    std::lock_guard<std::mutex> guard(m);
    //to check signal-slot
    qDebug()<<"flag inside back"<<flag;
    return;
}

BackController* BackController::instanceFactory()
{
    // C++11 specifies that the initialization can only happen
    // on one thread - no data race
    // https://timsong-cpp.github.io/cppwp/n4861/stmt.dcl
    static BackController controller;

    return &controller;
}
