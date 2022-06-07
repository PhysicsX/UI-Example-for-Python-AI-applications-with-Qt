#include "backController.h"


bool BackController::enableBack()
{
    //emit enableButton();
    m_backImage->setProperty("enabled",true);

    return true;
}

bool BackController::disableBack()
{
    //emit disableButton();
    m_backImage->setProperty("enabled",false);

    return true;
}

void BackController::setBackImage(QObject* it)
{
    m_backImage = it;
    //item->setProperty("enabled",false);
    return;
}

void BackController::changeText(QString txt)
{
    m_texNotification->setProperty("text",txt);
    return;
}


void BackController::setItemText(QObject* it)
{
    m_texNotification = it;
    //item->setProperty("enabled",false);
    return;
}

void BackController::setItemTextAnime(QObject* it)
{
    m_textAnime = it;
    return;
}

QString BackController::getText()
{
    return m_texNotification->property("text").toString();
}

void BackController::enableAnime()
{
    m_textAnime->setProperty("running",true);
    return;
}

void BackController::disableAnime()
{
    m_textAnime->setProperty("running",false);
    return;
}
void BackController::getVis(bool flag)
{
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
