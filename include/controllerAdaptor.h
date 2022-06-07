/*
    Adaptor Pattern for backend controller.
    Class is used by all menu items/objects/Childs
    to protect race conditions and for updating
    notifications in the main screen without any
    dependency directly to the menu items
*/

#pragma once
#include "backController.h"

// extend the backend controller interface
class ControllerAdaptor
{
    public:
    ControllerAdaptor();
    ~ControllerAdaptor();
    BackController* controller;
    BackController* getInstance();
};
