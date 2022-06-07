import QtQuick 2.12
import QtQuick.Controls 2.12
import com.ulasdikme.networkManager 1.0

Item {
    id: networkSettings
    width: parent.width
    height: parent.height
    signal example()

    objectName: "networkSettings"
    Component.onCompleted: {

        console.log("Network loaded");
        console.log(networkManager.enableDHCP);
        console.log(networkManager.enableAP);

        if(networkManager.enableDHCP)
        {
            control.readOnly = false;
            mask.readOnly = false;
            gateway.readOnly = false;
        }
        else
        {
            control.readOnly = true;
            mask.readOnly = true;
            gateway.readOnly = true;
        }
        tabBar.currentIndex = networkManager.enableDHCP;
	//connectionTab.currentIndex = networkManager.enableAP;
    }



    NetworkManager{
        id: networkManager
        //ipAddr: ipAddr
        onIpAddrChanged:{
            if(connectionTab.currentIndex === 0)
            {
                control.text = ipAddr;
                //console.log("ipaddr is updated");
            }
        }

        onMaskAddrChanged:{
            if(connectionTab.currentIndex === 0)
            {
                mask.text = maskAddr;
                //console.log("maskAddr is updated");
            }
        }

        onRouterAddrChanged:{
            if(connectionTab.currentIndex === 0)
            {
                gateway.text = routerAddr;
                //console.log("routerAddr is updated");
            }
        }

        onWlanIpAddrChanged:{
            if(connectionTab.currentIndex === 1)
            {
                control.text = wlanIpAddr;
                //console.log("Wipaddr is updated");
            }
        }

        onWlanMaskAddrChanged:{
            if(connectionTab.currentIndex === 1)
            {
                mask.text = wlanMaskAddr;
                //console.log("WmaskAddr is updated");
            }
        }

        onWlanRouterAddrChanged:{
            if(connectionTab.currentIndex === 1)
            {
                gateway.text = wlanRouterAddr;
                //console.log("WrouterAddr is updated");
            }
        }

        onEnableDHCPChanged:{
            if(connectionTab.currentIndex === 0)
            {
                tabBar.currentIndex = enableDHCP;
                //console.log("enableDHCP is updated");
            }
        }

        onEnableAPChanged:{
             if(connectionTab.currentIndex === 1)
             {
                tabBar.currentIndex = enableAP;
                //console.log("enableAP is updated");
             }
        }

        onButtonStatusChanged:{
            //disable apply button during network process
            controlButton.enabled = networkManager.buttonStatus;
        }

        onKeyWidthChanged:
        {
            console.log(keyWidth);
        }

        onKeyFlagChanged:
        {
            console.log(keyFlag);
            if(keyFlag === false)
            {
                flickable.contentY = 0
            }
            else if(keyFlag === true && control.activeFocus === true)
            {
                flickable.contentY = 32
            }
            else if(keyFlag === true && gateway.activeFocus === true)
            {
                flickable.contentY = 32*2 + 8
            }
            else if(keyFlag === true && mask.activeFocus === true)
            {
                flickable.contentY = 32*3 + 20
            }

        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        width: parent.width; height: parent.height
        contentWidth: parent.width; contentHeight: parent.height
        //anchors.margins: 20
        //anchors.bottomMargin: networkManager.keyFlag ? (networkManager.keyWidth - 380) : 10
        flickableDirection: Flickable.VerticalFlick

    Rectangle{
        width: 300
        height: 32
        y: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"

        Text {
            text: "Mode: "
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }

        TabBar {
            id: tabBar
            anchors.right: parent.right
            background: Rectangle {
                color: "transparent"
                //radius: 10
            }

            TabButton {
                id: tabDhcp
                height: 32
                width: 72
                text: "DHCP"
                font.pointSize: 12

                contentItem: Text {
                    text: tabDhcp.text
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }

                onClicked:{
                    control.readOnly = true;
                    mask.readOnly = true;
                    gateway.readOnly = true;
                }

                background: Rectangle {
                    id: tabRect
                    color: tabBar.currentIndex == 0 ? "blue" : "gray"
                    //radius: 10
                }
            }
            TabButton {
                id: tabStatic
                height: 32
                width: 72
                text: "STATIC"
                font.pointSize: 12


                contentItem: Text {
                    text: tabStatic.text
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }

                onClicked:{
                    control.readOnly = false;
                    mask.readOnly = false;
                    gateway.readOnly = false;
                }

                background: Rectangle {
                    id: tabRect2
                    color: tabBar.currentIndex == 1 ? "blue" : "gray"
                    //radius: 10
                }
            }
        }
    }


    Rectangle{
        width: 272
        height: 32
        y: 120
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        visible: false // this shoudl be true when AP will be enabled later

        Text {
            text: "Connection: "
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }

        TabBar {
            id: connectionTab
            anchors.right: parent.right
            background: Rectangle {
                color: "transparent"
                //radius: 10
            }

            TabButton {
                height: 32
                width: 72
                text: "Wired"
                font.pointSize: 12
                id: wiredTab
                contentItem: Text {
                    text: wiredTab.text
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }
                background: Rectangle {
                    color: connectionTab.currentIndex == 0 ? "blue" : "gray"
                    //radius: 10
                }
                onClicked:{
                    tabDhcp.text = "DHCP"
                    tabStatic.text = "STATIC"
                    tabBar.currentIndex = networkManager.enableDHCP;

                    if(networkManager.enableDHCP === false)
                    {
                        //console.log("dhcp mode active");
                        control.text = networkManager.ipAddr;
                        mask.text = networkManager.maskAddr;
                        gateway.text = networkManager.routerAddr;
                        control.readOnly = true;
                        mask.readOnly = true;
                        gateway.readOnly = true;

                    }
                    else if(networkManager.enableDHCP === true)
                    {
                        //console.log("static mode active");
                        control.text = networkManager.ipAddr;
                        mask.text = networkManager.maskAddr
                        gateway.text = networkManager.routerAddr
                        control.readOnly = false;
                        mask.readOnly = false;
                        gateway.readOnly = false;
                    }
                }
            }
            TabButton {
                width: 272
                height: 32
                text: "Wifi"
                font.pointSize: 16
                id: wifiTab
                contentItem: Text {
                    text: wifiTab.text
                    font.pointSize: 19
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }
                background: Rectangle {
                    color: connectionTab.currentIndex == 1 ? "blue" : "gray"
                    //radius: 10
                }

                onClicked:{
                    tabDhcp.text = "Hotspot"
                    tabStatic.text = "STATION"
                    tabBar.currentIndex = networkManager.enableAP; //enable ap mode !

                    if(networkManager.enableAP === false)
                    {
                        //console.log("ap mode active");
                        control.text = networkManager.wlanIpAddr;
                        mask.text = networkManager.wlanMaskAddr
                        gateway.text = networkManager.wlanRouterAddr
                        control.readOnly = true;
                        mask.readOnly = true;
                        gateway.readOnly = true;
                    }
                    else if(networkManager.enableAP === true)
                    {
                        //console.log("station mode active");
                        control.text = networkManager.wlanIpAddr;
                        mask.text = networkManager.wlanMaskAddr
                        gateway.text = networkManager.wlanRouterAddr
                        control.readOnly = true;
                        mask.readOnly = true;
                        gateway.readOnly = true;
                    }
                }
            }
        }
    }



    Rectangle{
        width: 300
        height: 32
        y: 60 //180
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"

        Text {
            text: "IP address: "
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }


        TextField {
            id: control
            anchors.right: parent.right

            validator: RegExpValidator{
                regExp:  /^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){0,3}(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/
            }

            text: networkManager.ipAddr
            color: acceptableInput ? "black" : "red"
            horizontalAlignment: TextInput.AlignHCenter

            font.pointSize: 10
            font.bold: true

            background: Rectangle {
                implicitWidth: 144
                implicitHeight: 18
                color: control.enabled ? "transparent" : "#353637"
                border.color: control.enabled ? "#21be2b" : "transparent"
            }

            onActiveFocusChanged: {
                if(activeFocus && control.readOnly===false)
                {
                    //inputPanel.visible = activeFocus
                    //var posWithinFlicable = mapToItem(networkSettings,0, height/2);
                    //flickable.contentY = posWithinFlicable.y - flickable.height/2;
                    flickable.contentY = 32
                }
            }

        }

    }

    Rectangle{
        width: 300
        height: 32
        y: 100 //240
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"

        Text {
            text: "Mask: "
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }


        TextField {
            id: mask
            anchors.right: parent.right
            text: networkManager.maskAddr //qsTr("255.255.255.0")
            validator: RegExpValidator{
                regExp:  /^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){0,3}(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/
            }
            color: acceptableInput ? "black" : "red"
            horizontalAlignment: TextInput.AlignHCenter

            font.pointSize: 10
            font.bold: true

            background: Rectangle {
                implicitWidth: 144
                implicitHeight: 18
                color: mask.enabled ? "transparent" : "#353637"
                border.color: mask.enabled ? "#21be2b" : "transparent"
            }

            onActiveFocusChanged: {
                if(activeFocus && control.readOnly===false)
                {
                    //inputPanel.visible = activeFocus
                    //var posWithinFlicable = mapToItem(networkSettings,0, height/2);
                    //flickable.contentY = posWithinFlicable.y - flickable.height/2;
                    flickable.contentY = 32*2 + 8
                }
            }

        }

    }

    Rectangle{
        width: 300
        height: 32
        y: 140 //300
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        id: gatewayRect

        Text {
            text: "Gateway: "
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }


        TextField {
            id: gateway
            anchors.right: parent.right
            text: networkManager.routerAddr //qsTr("192.168.137.1")
            horizontalAlignment: TextInput.AlignHCenter
            font.pointSize: 10
            font.bold: true
            validator: RegExpValidator{
                regExp:  /^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){0,3}(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/
            }
            color: acceptableInput ? "black" : "red"
            background: Rectangle {
                implicitWidth: 144
                implicitHeight: 18
                color: gateway.enabled ? "transparent" : "#353637"
                border.color: gateway.enabled ? "#21be2b" : "transparent"
            }



            onActiveFocusChanged: {
                if(activeFocus && control.readOnly===false)
                {
                    //inputPanel.visible = activeFocus
                    //var posWithinFlicable = mapToItem(networkSettings,0, height/2);
                    //flickable.contentY = posWithinFlicable.y - flickable.height/2;
                    flickable.contentY = 32*3 + 20
                }

            }
        }

    }

    Rectangle{
        width: 60
        height: 16
        y: 180 //355
        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.right: gatewayRect.right
        color: "transparent"


        Button {
            text: "Apply"
           // id:controlButton
            width: 60
            height: 20
            font.pointSize: 8
            background: Rectangle {
                implicitWidth: 20
                implicitHeight: 16
                border.width: control.activeFocus ? 2 : 1
                border.color: "#888"
                radius: 4
                gradient: Gradient {
                    GradientStop { position: 0 ; color: controlButton.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: controlButton.pressed ? "#aaa" : "#ccc" }
                }
            }
            objectName: "controlButton"
            signal qmlSignalForIpChange()
            id:controlButton


            onClicked:
            {
                controlButton.qmlSignalForIpChange()
//                console.log("Apply is clicked");
//                console.log("tabbar "+tabBar.currentIndex);
//                console.log("connectionTab "+connectionTab.currentIndex);

                    //if(connectionTab.currentIndex === 0) // this used for wifi selection
                    //{
                        if(tabBar.currentIndex === 0)
                        {
                            networkManager.applyNetwork(tabBar.currentIndex, connectionTab.currentIndex);
                            networkManager.enableDHCP = 0;
                        }
                        else if(tabBar.currentIndex === 1)
                        {
                            if(control.acceptableInput === true)
                            {
                                //console.log("static configuration");
                                networkManager.ipAddr = control.text;
                                networkManager.maskAddr = mask.text;
                                networkManager.routerAddr = gateway.text;
                                networkManager.setStatic();
                                networkManager.enableDHCP = 1;
                            }
                        }
                    //}
                    //else if(connectionTab.currentIndex === 1)
                    //{
                        //if(tabBar.currentIndex === 0)
                        //{
                            //networkManager.applyNetwork(tabBar.currentIndex, connectionTab.currentIndex);
                            //networkManager.enableAP = 0;
                        //}
                        //else if(tabBar.currentIndex === 1)
                        //{
                            //networkManager.applyNetwork(tabBar.currentIndex, connectionTab.currentIndex);
                            //networkManager.enableAP = 1; // station mode
                        //}

                    //}

            }
        }
    }
    }// end of flicker

}
