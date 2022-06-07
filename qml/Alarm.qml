import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 2.5
import com.ulasdikme.alarm 1.0

Item {

    id: alarmMain
    width: parent.width
    height: parent.height

    Component.onCompleted: {
        adminUpdateBUtton.visible = false;

        audio.checked = alarm.audio
        ledStatu.checked = alarm.ledStatu
        textF.checked = alarm.text
        email.checked = alarm.mail
        flashHigh.checked = alarm.flashHigh
        flashLow.checked = alarm.flashLow
    }


    Alarm
    {
        id: alarm

        onAudioChanged:
        {
            audio.checked = alarm.audio
        }

        onLedStatuChanged:
        {
            ledStatu.checked = alarm.ledStatu
        }

        onTextChanged:
        {
            textF.checked = alarm.text
        }

        onMailChanged:
        {
            email.checked = alarm.mail
        }
        onFlashHighChanged:
        {
            flashHigh.checked = alarm.flashHigh
        }
        onFlashLowChanged:
        {
            flashLow.checked = alarm.flashLow
        }
    }

    Rectangle
    {
        width: 470
        height: 50
        y: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"

        Rectangle{

            width: 180
            height: 150
            y:30
            color: "transparent"
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            //anchors.leftMargin: parent.width * 0.25
            id: fisrtRec
                CheckBox{
                    //checked: true
                    id: audio
                    text : qsTr("Activate Audio")
                    anchors.left: parent.left
                    font.pointSize: 12
                    indicator.width: 12
                    indicator.height: 12

                    onActiveFocusChanged:
                    {
                        adminUpdateBUtton.visible = true;
                    }
                }

                CheckBox{
                    //checked: true
                    id: textF
                    text : qsTr("Enable Text Feature")
                    y: 50
                    anchors.left: parent.left
                    font.pointSize: 12
                    indicator.width: 12
                    indicator.height: 12

                    onActiveFocusChanged:
                    {
                        adminUpdateBUtton.visible = true;
                    }

                }

                CheckBox{
                    //checked: true
                    id: email
                    text : qsTr("Activate Email Alarm")
                    y: 100
                    anchors.left: parent.left
                    font.pointSize: 12
                    indicator.width: 12
                    indicator.height: 12

                    onActiveFocusChanged:
                    {
                        adminUpdateBUtton.visible = true;
                    }

                }

        }

        Rectangle{

            width: 180
            height: 150
            y:30
            color: "transparent"
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: fisrtRec.right
            anchors.leftMargin: fisrtRec.width * 0.25
            id: secRect
                CheckBox{
                    //checked: true
                    id: ledStatu
                    text : qsTr("Enable LED Status")
                    y:0
                    anchors.left: parent.left
                    font.pointSize: 12
                    indicator.width: 12
                    indicator.height: 12

                    onActiveFocusChanged:
                    {
                        adminUpdateBUtton.visible = true;
                    }

                }

                CheckBox{
                    //checked: true
                    id: flashHigh
                    text : qsTr("Flash High Enable")
                    y:50
                    anchors.left: parent.left
                    font.pointSize: 12
                    indicator.width: 12
                    indicator.height: 12

                    onActiveFocusChanged:
                    {
                        adminUpdateBUtton.visible = true;
                    }

                }

                CheckBox{
                    //checked: true
                    id: flashLow
                    text : qsTr("Flash Low Enable")
                    y:100
                    anchors.left: parent.left
                    font.pointSize: 12
                    indicator.width: 12
                    indicator.height: 12

                    onActiveFocusChanged:
                    {
                        adminUpdateBUtton.visible = true;
                    }

                }
        }

                Button {

                    text: "Update"
                    id: adminUpdateBUtton
                    //anchors.top : parent.bottom
                   // anchors.left: control.right;
                    //anchors.margins: 10

                    anchors.right: secRect.right
                    anchors.top: secRect.bottom
                    anchors.topMargin: 2
                    //anchors.horizontalCenter: parent.horizontalCenter
                    width: 80
                    height: 20
                    background: Rectangle {
                        implicitWidth: 40
                        implicitHeight: 10
                        border.width: email.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 4
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: adminUpdateBUtton.pressed ? "#ccc" : "#eee" }
                            GradientStop { position: 1 ; color: adminUpdateBUtton.pressed ? "#aaa" : "#ccc" }
                        }
                    }
                    objectName: "hotspotButton"
                    signal adminUpdateBUtton()
                    onClicked:
                    {
                        alarm.applyChanges(audio.checked, textF.checked, email.checked, ledStatu.checked, flashHigh.checked, flashLow.checked);
                        adminUpdateBUtton.visible = false;

                    }
                }

    }
}


