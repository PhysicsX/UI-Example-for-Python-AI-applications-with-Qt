import QtQuick 2.0
import QtQuick.Controls 2.12
import com.ulasdikme.local 1.0

Item {

    id: localMain
    width: parent.width
    height: parent.height

    Rectangle{

        width: 400
        height: 300
        y:6
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter

        Component.onCompleted: {

            updateButton.visible = false

            timeText.text = local.time;
            dateText.text = local.date;

            if(local.temp === "Fahrenheit")
            {
                tempCombo.currentIndex = 0;

            }
            else
            {
                tempCombo.currentIndex = 1;
            }

            if(local.distance === "Feet")
            {
                comboDistance.currentIndex = 0;

            }
            else
            {
                comboDistance.currentIndex = 1;
            }
            cbItems.clear();

            console.log(local.currentId)
            var select = 0;
            for(var i = 0; i < local.zone.length; i++)
            {
                cbItems.append({"text": local.zone[i]})

                if(local.zone[i] === local.currentId)
                {
                    select = i
                }


            }

            zoneText.currentIndex = select
        }


        Local{

            id: local

            onZoneChanged:
            {
                cbItems.clear();

                console.log(local.currentId)
                var select = 0;
                for(var i = 0; i < local.zone.length; i++)
                {
                    cbItems.append({"text": local.zone[i]})

                    if(local.zone[i] === local.currentId)
                    {
                        select = i
                    }


                }

                zoneText.currentIndex = select
            }

            onCurrentIdChanged:
            {

            }

            onTimeChanged:
            {
                timeText.text = local.time;
            }

            onDateChanged:
            {
                dateText.text = local.date;
            }

            onTempChanged:
            {
                if(local.temp === "Fahrenheit")
                {
                    tempCombo.currentIndex = 0;

                }
                else
                {
                    tempCombo.currentIndex = 1;
                }
            }

            onDistanceChanged:
            {
                if(local.distance === "Feet")
                {
                    comboDistance.currentIndex = 0;

                }
                else
                {
                    comboDistance.currentIndex = 1;
                }
            }

        }

        Text {
            text: "Temp: "
            id: textName
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }

        ComboBox{
            width: 200
            anchors.right:  parent.right
            id:tempCombo
            model: ["Fahrenheit", "Celcius"]
            background: Rectangle {
                implicitWidth: 144
                implicitHeight: 18
            }
            onActiveFocusChanged:
            {
                updateButton.visible = true
            }
        }

        Text {
            text: "Distance: "
            id: distance
            y: 40
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }

        ComboBox{
            width: 200
            y: 40
            anchors.right:  parent.right
            model: ["Feet", "Meter"]
            id: comboDistance
            background: Rectangle {
                implicitWidth: 144
                implicitHeight: 18
            }
            onActiveFocusChanged:
            {
                updateButton.visible = true
            }
        }

        Text {
            text: "Time: "
            id: time
            y: 80
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }

        TextField {
            id: timeText
            y: 80
            anchors.right:  parent.right
            text: "12:22"
            color: acceptableInput ? "black" : "red"
            readOnly: true
            font.pointSize: 10
            font.bold: true

            validator: RegExpValidator
            {
                regExp:/^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/
            }
            // /(?:[01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)/
            background: Rectangle {
                implicitWidth: 144
                implicitHeight: 18
                color: timeText.enabled ? "transparent" : "#353637"
                border.color: timeText.enabled ? "#21be2b" : "transparent"
            }

            onActiveFocusChanged:
            {
                updateButton.visible = timeText.acceptableInput ? true : false
            }



        }

        Text {
            text: "Date: "
            id: date
            y: 120
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }

        TextField {
            id: dateText
            y: 120
            readOnly: true
            anchors.right:  parent.right
            text: "02/02/2016"
            color: acceptableInput ? "black" : "red"
            font.pointSize: 10
            font.bold: true

            validator: RegExpValidator
            {
                regExp:/^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.]\d\d$/
            }

            onActiveFocusChanged:
            {
                updateButton.visible = dateText.acceptableInput ? true : false
            }



            background: Rectangle {
                implicitWidth: 144
                implicitHeight: 18
                color: dateText.enabled ? "transparent" : "#353637"
                border.color: dateText.enabled ? "#21be2b" : "transparent"
            }


        }

        Text {
            text: "Zone: "
            id: zone
            y: 160
            anchors.left: parent.left
            font.family: "Helvetica"
            font.pointSize: 18
            font.bold: true
            color: "black"
        }

        ComboBox{
            width: 200
            id: zoneText
            y: 160
            anchors.right:  parent.right
            background: Rectangle {
                implicitWidth: 144
                implicitHeight: 18
            }
            model: ListModel {
                id: cbItems
                        ListElement { text: "Banana"}
                }

            onActiveFocusChanged:
            {
                updateButton.visible = true
            }

        }

        Button {
            text: "Reboot"
            y : 195
            anchors.left: parent.left
            background: Rectangle {
                implicitWidth: 20
                implicitHeight: 16
                border.width: zoneText.activeFocus ? 2 : 1
                border.color: "#888"
                radius: 4
                gradient: Gradient {
                    GradientStop { position: 0 ; color: rebootButton.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: rebootButton.pressed ? "#aaa" : "#ccc" }
                }
            }

            onClicked:
            {
                local.reboot();

            }
            id: rebootButton
        }

        Button {
            text: "Shutdown"
            y : 195
            anchors.left: rebootButton.left
            anchors.leftMargin: rebootButton.width + 20
            background: Rectangle {
                implicitWidth: 20
                implicitHeight: 16
                border.width: zoneText.activeFocus ? 2 : 1
                border.color: "#888"
                radius: 4
                gradient: Gradient {
                    GradientStop { position: 0 ; color: shutdownButton.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: shutdownButton.pressed ? "#aaa" : "#ccc" }
                }
            }
            id: shutdownButton
            onClicked:
            {
                local.shutdown();

            }
        }

        Button {

            text: "Update"
            //anchors.top : parent.bottom
           // anchors.left: control.right;
            //anchors.margins: 10
            y : 195
            anchors.right: parent.right
            //anchors.topMargin: 40
            //anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                implicitWidth: 20
                implicitHeight: 16
                border.width: zoneText.activeFocus ? 2 : 1
                border.color: "#888"
                radius: 4
                gradient: Gradient {
                    GradientStop { position: 0 ; color: updateButton.pressed ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: updateButton.pressed ? "#aaa" : "#ccc" }
                }
            }
            objectName: "hotspotButton"
            signal hotspotButton()
            id: updateButton
            onClicked:
            {
                updateButton.visible = false
                local.applyChanges(tempCombo.currentText, comboDistance.currentText,"dummy","dummy",zoneText.currentText);

            }
        }

    }
}
