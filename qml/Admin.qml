import QtQuick 2.12
import QtQuick.Controls 2.12
import com.ulasdikme.admin 1.0


Item {
    width: parent.width
    height: parent.height
    id: adminSettings
    signal example()
        visible: true
    objectName: "adminSettings"

    Component.onCompleted: {
        adminUpdateBUtton.visible = false;

        control.text = admin.name
        surnameField.text = admin.surname
        phone.text = admin.phoneNumber
        email.text = admin.mail
    }

    Admin
    {
        id: admin
        //name: "ginaa"
        onNameChanged:
        {
            control.text = name;
        }

        onSurnameChanged:
        {
            surnameField.text = surname
        }

        onMailChanged:
        {
            phone.text = phoneNumber
        }

        onPhoneNumberChanged:
        {
            email.text = mail
        }

        onKeyFlagChanged:
        {
            // TODO: Check why contentY is getting to zero

            if(keyFlag === false)
            {
                flickable.contentY = 0
            }
            else if(keyFlag === true && control.activeFocus === true)
            {
                flickable.contentY = 32
            }
           // flickable.anchors.bottomMargin = keyFlag ? 500 : anchors.margins;
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        width: parent.width; height: parent.height
        contentWidth: parent.width; contentHeight: parent.height
        //anchors.margins: 20
        //anchors.bottomMargin: admin.keyFlag ? (admin.keyWidth-400) : 30
        flickableDirection: Flickable.VerticalFlick
        onContentYChanged:
        {
            if(admin.keyFlag === true && control.activeFocus === true)
            {
                flickable.contentY = 32
            }
            else if(admin.keyFlag === true && surnameField.activeFocus === true)
            {
                flickable.contentY = 32 + 26
            }
            else if(admin.keyFlag === true && phone.activeFocus === true)
            {
                flickable.contentY = 32 + 26*2
            }
            else if(admin.keyFlag === true && email.activeFocus === true)
            {
                flickable.contentY = 32 + 26*3
            }
        }

    Rectangle{
        id: adminMain
        width: 300
        height: 260
        y:30
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "Name: "
                id: textName
                anchors.left: parent.left
                font.family: "Helvetica"
                font.pointSize: 18
                font.bold: true
                color: "black"
            }

            TextField {
                id: control
                anchors.right:  parent.right
                //placeholderText: "Gina"
                color: "black"
                font.pointSize: 10
                font.bold: true
                validator: RegExpValidator
                {
                    regExp:/(^[A-Za-z0-9_-]{0,15}$)/
                }

                background: Rectangle {
                    implicitWidth: 144
                    implicitHeight: 18
                    color: control.enabled ? "transparent" : "#353637"
                    border.color: control.enabled ? "#21be2b" : "transparent"
                }

                onActiveFocusChanged: {
                    adminUpdateBUtton.visible = true;
                    if(activeFocus)
                    {
                        //inputPanel.visible = activeFocus
                        //var posWithinFlicable = mapToItem(parent,0, height/2);
                        //flickable.contentY = posWithinFlicable.y - flickable.height/2;
                        flickable.contentY = 32

                    }
                }
                onTextChanged:
                {
                control.text = text;
                }

                TapHandler{
                    onTapped: {
                        adminUpdateBUtton.visible = true;
                    }
                }

            }


            Text {
                text: "Surname: "
                id: surname
                y: 40
                anchors.left: parent.left
                font.family: "Helvetica"
                font.pointSize: 18
                font.bold: true
                color: "black"
            }

            TextField {
                id: surnameField
                y: 40
                anchors.right:  parent.right
                //placeholderText: "Atkins"
                validator: RegExpValidator{
                    regExp:/(^[A-Za-z0-9_-]{0,15}$)/
                }

                color: "black"
                font.pointSize: 10
                font.bold: true

                background: Rectangle {
                    implicitWidth: 144
                    implicitHeight: 18
                    color: surnameField.enabled ? "transparent" : "#353637"
                    border.color: surnameField.enabled ? "#21be2b" : "transparent"
                }

                onActiveFocusChanged: {

                    adminUpdateBUtton.visible = true;
                    console.log("surnameField activeFocus ",activeFocus);
                    if(activeFocus)
                    {
                        console.log("surnameField activeFocus ",activeFocus);

                        //inputPanel.visible = activeFocus
                        //var posWithinFlicable = mapToItem(parent,0, height/2);
                        //flickable.contentY = posWithinFlicable.y - flickable.height/2;
                        flickable.contentY = 30 + 40

                    }
                }

                TapHandler{
                    onTapped: {
                        adminUpdateBUtton.visible = true;
                    }
                }

            }

            Text {
                text: "Phone: "
                id: phoneText
                y: 80
                anchors.left: parent.left
                font.family: "Helvetica"
                font.pointSize: 18
                font.bold: true
                color: "black"
            }

            TextField {
                id: phone
                y: 80
                anchors.right:  parent.right
                //placeholderText: "555 256 54 23"
                color: "black"
                font.pointSize: 10
                validator: RegExpValidator{
                    regExp:  /^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/
                }

                font.bold: true

                background: Rectangle {
                    implicitWidth: 144
                    implicitHeight: 18
                    color: phone.enabled ? "transparent" : "#353637"
                    border.color: phone.enabled ? "#21be2b" : "transparent"
                }
                onActiveFocusChanged: {

                    adminUpdateBUtton.visible = true;
                    if(activeFocus)
                    {
                        //admin.keyFlag = activeFocus
                        //var posWithinFlicable = mapToItem(parent,0, height/2);
                        //flickable.contentY = posWithinFlicable.y - flickable.height/2;
                        flickable.contentY = 30 + 40*2

                    }

                }
                TapHandler{
                    onTapped: {
                        adminUpdateBUtton.visible = true;
                    }
                }

            }

            Text {
                text: "Email: "
                id: emailText
                y: 120
                anchors.left: parent.left
                font.family: "Helvetica"
                font.pointSize: 18
                font.bold: true
                color: "black"
            }

            TextField {
                id: email
                y: 120
                anchors.right:  parent.right
                text: "gina@gmail.com"
                validator: RegExpValidator { regExp:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
                color: acceptableInput ? "black" : "red"

                font.pointSize: 10
                font.bold: true

                background: Rectangle {
                    implicitWidth: 144
                    implicitHeight: 18
                    color: email.enabled ? "transparent" : "#353637"
                    border.color: email.enabled ? "#21be2b" : "transparent"
                }
                onTextChanged:
                {
                    adminUpdateBUtton.visible = email.acceptableInput ? true : false;
                }
                onActiveFocusChanged: {

                    adminUpdateBUtton.visible = true;
                    if(activeFocus)
                    {
                        //admin.keyFlag = activeFocus
                        //var posWithinFlicable = mapToItem(parent,0, height/2);
                        //flickable.contentY = posWithinFlicable.y - flickable.height/2;
                        //console.log(flickable.contentY)
                        flickable.contentY = 30 + 40*2
                    }

                }

                TapHandler{
                    onTapped: {
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
                width: 60
                height: 20
                font.pointSize: 8
                y : 160
                anchors.right: parent.right
                //anchors.topMargin: 40
                //anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    implicitWidth: 20
                    implicitHeight: 16
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
                    admin.applyChanges(control.text, surnameField.text, phone.text, email.text);
                    adminUpdateBUtton.visible = false;

                }
            }
            }


    }
}
