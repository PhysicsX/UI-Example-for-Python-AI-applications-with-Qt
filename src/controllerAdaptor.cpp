#include "controllerAdaptor.h"

ControllerAdaptor::ControllerAdaptor()
{

}

ControllerAdaptor::~ControllerAdaptor()
{

}

BackController* ControllerAdaptor::getInstance()
{
    controller = BackController::instanceFactory();
    return controller;
}
