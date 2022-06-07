import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.12
import com.ulasdikme.wifiConf 1.0

Item {
    property bool flagToUpt: false;
    width: parent.width
    height: parent.height
    visible: true
    id: wifiSettings
    Component.onCompleted: {

        connectButton.enabled = false


        if(!wifiConf.disableWifi)
        {
            if(wifiConf.currentSsid.toString() === '')
            {
                disconButton.enabled = false;
            }
            else
            {
                disconButton.enabled = true;
            }

            model.clear();

            if(!wifiConf.enableHot)
            {
                station.visible = true;
                hotspot.visible = false;

                var select
                for(var i = 0; i < wifiConf.ssidNames.length; i++)
                {

                    model.append({name: wifiConf.ssidNames[i], number: wifiConf.ssidStr[i]});

                    if( (wifiConf.currentSsid.toString()).localeCompare(wifiConf.ssidNames[i]. toString()) === 0)
                    {
                        select = i
                        // do not update the list.currentIndex here it will be unvalidated
                        //model.clear();
                    }
                }

                    list.currentIndex = select
                    flagToUpt = true;


            }
            else
            {
                station.visible = false;
                hotspot.visible = true;
		hotspot.z = 90;
		station.z = 10;
            }
        }
        else
        {
            station.visible = false;
            hotspot.visible = false;
        }
        //console.log(wifiConf.ssidNames.length)
        //console.log(wifiConf.ssidNames[2])

//        model.append({name: "ssid1", number: "strong"});
//        model.append({name: "ssid2", number: "strong"});
//        model.append({name: "ssid3", number: "normal"});
//        model.append({name: "ssid4", number: "weak"});
//        model.append({name: "ssid5", number: "weak"});
    }

    WifiConf{
    id: wifiConf
        onSsidNamesChanged:
        {
            //console.log("ssids updated");
            model.clear();
            var select
            for(var i = 0; i < wifiConf.ssidNames.length; i++)
            {
                model.append({name: wifiConf.ssidNames[i], number: wifiConf.ssidStr[i] });

                if( (wifiConf.currentSsid.toString()).localeCompare(wifiConf.ssidNames[i]. toString()) === 0)
                {
                    select = i
                    // do not update the list.currentIndex here it will be unvalidated
                    //model.clear();
                }
            }
                list.currentIndex = select
                flagToUpt = true;

        }


        onSsidStrChanged:
        {
            //console.log("ssids updated");
            model.clear();
            var select
            for(var i = 0; i < wifiConf.ssidNames.length; i++)
            {
                model.append({name: wifiConf.ssidNames[i], number: wifiConf.ssidStr[i] });

                if( (wifiConf.currentSsid.toString()).localeCompare(wifiConf.ssidNames[i]. toString()) === 0)
                {
                    select = i
                    // do not update the list.currentIndex here it will be unvalidated
                    //model.clear();
                }
            }
                list.currentIndex = select
                flagToUpt = true;

            //scanBtn.enabled = true;

        }

        onEnableStatChanged:
        {

            station.visible = true;
            hotspot.visible = false;

            model.clear();
            var select
            for(var i = 0; i < wifiConf.ssidNames.length; i++)
            {

                model.append({name: wifiConf.ssidNames[i], number: wifiConf.ssidStr[i]});

                if( (wifiConf.currentSsid.toString()).localeCompare(wifiConf.ssidNames[i]. toString()) === 0)
                {
                    select = i
                    // do not update the list.currentIndex here it will be unvalidated
                    //model.clear();
                }
            }

                list.currentIndex = select
                flagToUpt = true;

            //console.log("ssids updated");
            model.clear();
            for(i = 0; i < wifiConf.ssidNames.length; i++)
            {
                model.append({name: wifiConf.ssidNames[i], number: wifiConf.ssidStr[i] });

                if( (wifiConf.currentSsid.toString()).localeCompare(wifiConf.ssidNames[i]. toString()) === 0)
                {
                    select = i
                    // do not update the list.currentIndex here it will be unvalidated
                    //model.clear();
                }
            }
                list.currentIndex = select
                flagToUpt = true;

            //hotspot.enabled = true;
        }

        onKeyWidthChanged:
        {
            //console.log(keyWidth);
        }

        onEnableScanButtonChanged:
        {
            scanBtn.enabled = wifiConf.enableScanButton
        }

        onIpAddrChanged:
        {
            disconButton.enabled = true;
        }

        onEnableHotChanged:
        {
            station.visible = false;
            hotspot.visible = true;
	    hotspot.z = 90;
	    station.z = 10;
	 }

        onKeyFlagChanged:
        {
            console.log("keyflag ",keyFlag);
            console.log("focus ", passwordText.activeFocus); 
	
            if(keyFlag === false)
            {
                flickable.contentY = 0
            }
            else if(keyFlag === true && passwordText.activeFocus === true)
            {
                flickable.contentY = 30
            }
        }
    }



    Rectangle
    {
        width: 300
        height: 120
        color:"transparent"
        //anchors.top: parent.top
        y : 10
        anchors.horizontalCenter: parent.horizontalCenter
        Text {

            color: "green"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            text: wifiConf.disableWifi ? "" : wifiConf.enableHot ? 'Enable station mode' : 'choose to connect'
         }
    }

    Rectangle
    {
        id: hotspot
        width: 300
        height: 180
        y: 40
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter

        CheckBox{
            checked: false
            id: enable
            text : qsTr("Activate station wifi mode")
            font.pointSize: 12                    
            indicator.width: 12
            indicator.height: 12
  
            anchors.left: parent.left

            onCheckedChanged:
            {
                enabled = false
		wifiConf.enableStatMode();
                console.log("checkbox is checked");
                hotspot.z=90;
            }
        }


    }





    Rectangle
    {
        width: 300
        height: 120
        y: 30
        color: "transparent"
        id: station
        z:90
        anchors.horizontalCenter: parent.horizontalCenter

        ListModel {
            id: model
            ListElement {
               name:'ssid1'
               number:'strong'
            }
        }

        ScrollView
        {
            width:300
            height: 120
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy : ScrollBar.AlwaysOn

            id: scrollbarItem

            ListView {
                id: list
                anchors.fill: parent
                model: model

                delegate: Component {
                    Item {
                        width: parent.width
                        height: 30
                        Row {
                            spacing: 20

                                Text {
                                    color: "blue"
                                    font.pixelSize: 16
                                    font.weight: Font.DemiBold
                                    //text: 'Name: ' + name
                                    text:name
                                   }
                                 Text {
                                     color: "blue"
                                     font.pixelSize: 16
                                     font.weight: Font.DemiBold
                                     text: number
                                        }


                            TapHandler{
                                //onDoubleTapped:
                                onTapped:
                                {
                                    list.currentIndex = index
                                    flagToUpt = true;
                                    connectButton.enabled = true
                                    //console.log(flagToUpt)
                                    //rec2.color = "black";
                                }

                            }
                        }

                    }
                }
                highlight: Rectangle {
                    id: rec2
                    color: flagToUpt ? 'black' : 'transparent'
                    opacity: 0.3

                    Text {
                        z : 40

                        //anchors.centerIn: parent
                        //anchors.bottom: parent.bottom
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        //text: 'Connect to ' + model.get(list.currentIndex).name
                        color: flagToUpt ? 'white' : 'transparent'
                        font.pixelSize: 18
                    }
                }
                focus: true
                onCurrentItemChanged: console.log(model.get(list.currentIndex).name + ' selected')
            }

        }

        Button {

            text: "Connect"
            anchors.top : parent.bottom
            //anchors.margins: 10
            anchors.margins: 200
            anchors.topMargin: 20
            anchors.right: parent.right
            font.pointSize: 8
            //anchors.horizontalCenter: parent.horizontalCenter
            width: 80
            height: 20
            background: Rectangle {
                implicitWidth: 40
                implicitHeight: 10
                border.width: control.activeFocus ? 2 : 1
                border.color: "#888"
                radius: 4
                gradient: Gradient {
                    GradientStop { position: 0 ; color: connectButton.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: connectButton.pressed ? "#aaa" : "#ccc" }
                }
            }
            objectName: "connectButton"
            signal connetButtonSıgnal()
            id:connectButton
            onClicked:
            {
                //console.log(control.text);
                //console.log(model.get(list.currentIndex).name);
                //console.log("connect network is clicked");
                //wifiConf.connectToNetwork(model.get(list.currentIndex).name, control.text);
                passwordScreen.visible = true
                passwordScreen.z = 99
                station.color = ":gray";
                station.opacity = 0.1
                connectButton.enabled = false
                scanBtn.enabled = false
                list.visible = false
                station.z = 0;
                passwordText.z = 99;

            }
        }

            Button {

                text: "Disconnect"
                anchors.top : parent.bottom
                //anchors.margins: 10
                anchors.margins: 100
                anchors.topMargin: 20
                anchors.right: parent.right
                font.pointSize: 8 
                //anchors.horizontalCenter: parent.horizontalCenter
                width: 80
                height: 20
                background: Rectangle {
                    implicitWidth: 90
                    implicitHeight: 30
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 4
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: disconButton.pressed ? "#ccc" : "#eee" }
                        GradientStop { position: 1 ; color: disconButton.pressed ? "#aaa" : "#ccc" }
                    }
                }
                objectName: "disconnectButton"
                signal disconnectButtonSıgnal()
                id:disconButton
                onClicked:
                {
                    disconButton.enabled = false;
                    wifiConf.dissconnect();
                    flagToUpt = false;
                }
            }

            Button {
            text: "Rescan"
            anchors.top : parent.bottom
            anchors.margins: 0
            anchors.topMargin: 20
            anchors.right: parent.right
            font.pointSize: 8 
            width: 80
            height: 20
            background: Rectangle {
                implicitWidth: 90
                implicitHeight: 30
                border.width: control.activeFocus ? 2 : 1
                border.color: "#888"
                radius: 4
                gradient: Gradient {
                    GradientStop { position: 0 ; color: scanBtn.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: scanBtn.pressed ? "#aaa" : "#ccc" }
                }
            }
            objectName: "scanBtn"
            signal rescanButtonSıgnal()
            id:scanBtn
            onClicked:
            {
                //console.log("scanBtn is clicked");
                wifiConf.reScan();
                scanBtn.enabled = false;
            }
            }

            Rectangle
            {
                id: enableHotspot
                anchors.top : scanBtn.bottom
                color: "transparent"
                anchors.right: parent.left

                CheckBox{
                    //checked: true
                    //id: enable
                    text : qsTr("Activate wifi hotspot mode")
                    font.pointSize: 12                    
                    indicator.width: 12
                    indicator.height: 12
                    anchors.left: parent.left

                    onCheckedChanged:
                    {
                        //enabled = false

                        wifiConf.updateHotspot("Tempo", "Epilog2021");
                        station.visible = false;
                        hotspot.z = 91;
                        station.z = 10;
			hotspot.enabled = true;
                        hotspot.checked = false;
                        console.log("wifi hotspot mode checkbox is checked");
                    }
                }


            }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        width: 400; height: 400
        contentWidth: parent.width; contentHeight: parent.height
        //anchors.margins: 20
        //anchors.bottomMargin: wifiConf.keyFlag ? (wifiConf.keyWidth - 420) : 30
        flickableDirection: Flickable.VerticalFlick

            Rectangle
            {
                id: passwordScreen
                width: 300
                height: 160
                x : (parent.width / 2) - 160
                y : (parent.height / 2) - 120
                color: "blue"

                border.color: black
                border.width: 5
                radius: 10
                visible: false



                TextField
                {
                    id: passwordText
                    width: 200
                    height: 30
                    placeholderText: "Enter password"
                    //echoMode: TextInput.Password
                    //anchors.top : parent.bottom
                    x : parent.width - 250
                    y : parent.height - 110
                    anchors.margins: 40
                    maximumLength: 32


                    onActiveFocusChanged: {
                        if(activeFocus)
                        {
                            //inputPanel.visible = activeFocus
                            //var posWithinFlicable = mapToItem(wifiSettings,0, height/2);
                            //flickable.contentY = posWithinFlicable.y - flickable.height/2;
                            flickable.contentY = 30  
			}
                    }

                    onTextChanged:
                    {
                        if(passwordText.text === "")
                        {
                            passwordScreenButton.enabled = false
                        }
                        else
                        {
                            passwordScreenButton.enabled = true
                        }
                    }
                }


                         Button {

                             text: "OK"
                             //anchors.margins: 10
                             x : parent.width - 180
                             y : parent.height - 50
                             background: Rectangle {
                                 implicitWidth: 90
                                 implicitHeight: 30
                                 border.width: control.activeFocus ? 2 : 1
                                 border.color: "#888"
                                 radius: 4
                                 gradient: Gradient {
                                     GradientStop { position: 0 ; color: passwordScreenButton.pressed ? "#ccc" : "#eee" }
                                     GradientStop { position: 1 ; color: passwordScreenButton.pressed ? "#aaa" : "#ccc" }
                                 }
                             }
                             id:passwordScreenButton

                             enabled: false

                             onClicked:
                             {
                                passwordScreen.visible = false
                                passwordScreen.z = 1
                                station.color = "transparent"
                                station.opacity = 1.0
                                //connectButton.enabled = true
                                scanBtn.enabled = true
                                wifiConf.connectToNetwork(model.get(list.currentIndex).name, passwordText.text);
                                passwordText.text = ""
                                list.visible = true
                                 station.z = 99;
                                 passwordText.z = 1;
                             }
                         }
            }

    }




}
