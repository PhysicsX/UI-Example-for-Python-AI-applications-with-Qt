import QtQuick 2.15
import QtQuick.Window 2.12
import QtMultimedia 5.12
import QtQuick.Controls.Styles 1.2
import QtQuick.VirtualKeyboard 2.4
import QtQuick.Controls 2.3
import QtQuick.VirtualKeyboard.Settings 2.2
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

Window {
    id: windowMain
    visible: true
    width: 480
    height: 272


    property double resWidth: windowMain.width/800
    property double resHeight: windowMain.height/480
    property var flagScreen: false
//	Component.onCompleted:
//	{
//		console.log(resWidth)
//		console.log(resHeight)
//		console.log(windowMain.width/800)
//		console.log(windowMain.height)
//	}

    property var gstPipeline: "gst-pipeline: shmsrc socket-path=/tmp/foo do-timestamp=true ! video/x-raw, format=(string)BGR, width=(int)840, height=(int)480, framerate=(fraction)30/1 ! videoflip method=horizontal-flip ! autovideoconvert ! qtvideosink"
    Timer {
        id: timerSource
        interval: 500;
        running: false;
        repeat: true

        onTriggered: {
            console.log("check media periodically")
            player.source = gstPipeline
            player.play()
       	    flagScreen = false
	    timerSource.stop()	
	}

    }

    Timer {
        id: timerCaptured
        interval: 500;
        running: false;
        repeat: true
        property int seconds : 0;

        onTriggered: {
            console.log("check ",seconds)
            seconds ++;
            if(seconds > 20)
            {
                console.log("time to stop ",seconds)

                capturedData.visible = false;
                streaming.visible = true;
                seconds = 0;
                timerCaptured.stop();
            }
        }

    }

    Rectangle{

        id: capturedData
        objectName: "capturedData"
        width: parent.width
        height: parent.height
        visible: false
        color: "gray"

        Rectangle {

            width: parent.width
            height: parent.height
            color: "gray"

            property int bodyTempValue: 50
            property string bodyTempTemp : "blue"

            property int spo2Val: 50
            property string spo2ValColor: "blue"

            property int sweatVal: 50
            property string sweatValColor: "blue"

            property int healthVal: 50
            property string healthValColor: "blue"

            property int exposureVal: 50
            property string exposureValColor: "blue"

            Rectangle
            {
                id: rightRect
                width: 180
                height: 272
                color: "transparent"
                opacity: 0.4
                anchors.right: parent.right
                anchors.top: parent.top
                //anchors.margins: 20 // Sets all margins at once
                z:93
            }

             //temp
            Rectangle
            {
                y: 30
                id: rectHeatText;
                width: 50
                height: 15
                anchors.left: rightRect.left
                color: "transparent"
                anchors.leftMargin: 10

                Text {
                    text: "Temp: "
                    font.family: "Helvetica"
                    font.pointSize: 10
                    color: "black"
                    font.bold: true
                }

                z:99
            }
            Rectangle
            {
                y: 30
                id: rectHeat;
                width: 50
                height: 15
                color: "blue"
                opacity: 1
                anchors.left: rectHeatText.right
                z:99
            }

            Rectangle
            {
                y: 30
                id: rectHeatNeg;
                width: 100-rectHeat.width
                height: 15
                color: "black"
                opacity: 0.2
                anchors.left: rectHeat.right;
                z:99
            }

            // sweat
            Rectangle
            {
                y: 60
                id: rectSweatText;
                width: 50
                height: 15
                anchors.left: rightRect.left
                color: "transparent"
                anchors.leftMargin: 10

                Text {
                    text: "Sweat: "
                    font.family: "Helvetica"
                    font.pointSize: 10
                    color: "black"
                    font.bold: true
                }

                z:99
            }

            Rectangle
            {
                y: 60
                id: rectSweat;
                width: 50
                height: 15
                color: "blue"
                opacity: 1
                anchors.left: rectSweatText.right
                z:99
            }

            Rectangle
            {
                y: 60
                id: rectSweatNeg;
                width: 100-rectSweat.width
                height: 15
                color: "black"
                opacity: 0.2
                anchors.left: rectSweat.right;
                z:99
            }

            //heart
            Rectangle
            {
                y: 90
                id: rectHeartText;
                width: 50
                height: 15
                anchors.left: rightRect.left
                color: "transparent"
                anchors.leftMargin: 10

                Text {
                    text: "Heart: "
                    font.family: "Helvetica"
                    font.pointSize: 10
                    color: "black"
                    font.bold: true
                }
                z:99
            }

            Rectangle
            {
                y: 90
                id: rectHeart;
                width: 50
                height: 15
                color: "blue"
                opacity: 1
                anchors.left: rectHeartText.right
                z:99
            }

            Rectangle
            {
                y: 90
                id: rectHeartNeg;
                width: 100 - rectHeart.width
                height: 15
                color: "black"
                opacity: 0.2
                anchors.left: rectHeart.right;
                z:99
            }

            //oxygen
            Rectangle
            {
                y: 120
                id: rectOxygenText;
                width: 50
                height: 15
                anchors.left: rightRect.left
                color: "transparent"
                anchors.leftMargin: 10

                Text {
                    text: "Oxygen: "
                    font.family: "Helvetica"
                    font.pointSize: 9
                    color: "black"
                    font.bold: true
                }
                z:99
            }

            Rectangle
            {
                y: 120
                id: rectOxygen
                width: 50
                height: 15
                color: "blue"
                opacity: 1
                anchors.left: rectOxygenText.right
                z:99
            }

            Rectangle
            {
                y: 120
                id: rectOxygenNeg;
                width: 100 - rectOxygen.width
                height: 15
                color: "black"
                opacity: 0.2
                anchors.left: rectOxygen.right;
                z:99
            }

            //health
            Rectangle
            {
                y: 150
                id: rectHealthText;
                width: 50
                height: 15
                anchors.left: rightRect.left
                color: "transparent"
                anchors.leftMargin: 10

                Text {
                    text: "Health: "
                    font.family: "Helvetica"
                    font.pointSize: 10
                    color: "black"
                    font.bold: true
                }
                z:99
            }

            Rectangle
            {
                y: 150
                id: recthHealth
                width: 50
                height: 15
                color: "blue"
                opacity: 1
                anchors.left: rectHealthText.right
                z:99
            }

            Rectangle
            {
                y: 150
                id: rectHealthNeg;
                width: 100-recthHealth.width
                height: 15
                color: "black"
                opacity: 0.2
                anchors.left: recthHealth.right;
                z:99
            }

            //exposure
            Rectangle
            {
                y: 180
                id: exposureText;
                width: 50
                height: 15
                anchors.left: rightRect.left
                color: "transparent"
                anchors.leftMargin: 10

                Text {
                    text: "Expo: "
                    font.family: "Helvetica"
                    font.pointSize: 10
                    color: "black"
                    font.bold: true
                }

                z:99
            }

            Rectangle
            {
                y: 180
                id: rectExpo
                width: 50
                height: 15
                color: "blue"
                opacity: 1
                anchors.left: exposureText.right
                z:99
            }

            Rectangle
            {
                y: 180
                id: rectExpoNeg;
                width: 100-rectExpo.width
                height: 15
                color: "black"
                opacity: 0.2
                anchors.left: rectExpo.right;
                z:99
            }

            Rectangle
            {
                id: imageRect
                width: 150
                height: 180
                anchors.fill: imageRect
                anchors.left: parent.right
                anchors.topMargin: 8

                //y: 25
                //anchors.right: rightRect.left
                color: "black"

                Image{
                   id: imageRectImg
                   width: imageRect.width
                   height: imageRect.height
                   //source:image
                   fillMode: Image.Stretch
                }
            }

            Rectangle
            {

                id: imageRectBttm
                width: 150
                height: 150
                anchors.left: imageRect.right
                anchors.right: rightRect.left
                anchors.top : imageRect.top
                //anchors.top: imageRect.bottom
                anchors.bottom: imageRect.bottom
                color: "black"

                Image{
                   id:imageRectBttmImg
                   width: imageRectBttm.width
                   height: imageRectBttm.height
                   //source:image2
                   fillMode: Image.Stretch
                }
            }

        }

        signal currentDataSignal(string path, int temp, int reflectivity, int heartRate, int sp02, int health, int exposure)
        onCurrentDataSignal:
        {
            console.log(path)
            console.log(temp)
            console.log(reflectivity)
            console.log(heartRate)
            console.log(sp02)
            console.log(health)
            console.log(exposure)

            if(temp >=0 && temp<=100)
            {
                rectHeat.width = temp;
            }
            else
            {
                rectHeat.width = 0;
            }

            if(temp < 25)
            {
                rectHeat.color = "blue"
            }
            else if(temp >= 25 && temp < 50)
            {
                rectHeat.color = "green"
            }
            else if(temp >= 50 && temp < 75)
            {
                rectHeat.color = "orange"
            }
            else if(temp >= 75 && temp <= 100)
            {
                rectHeat.color = "red"
            }

            rectSweat.width = reflectivity;
            if(reflectivity < 25)
            {
                rectSweat.color = "blue"
            }
            else if(reflectivity >= 25 && reflectivity < 50)
            {
                rectSweat.color = "green"
            }
            else if(reflectivity >= 50 && reflectivity < 75)
            {
                rectSweat.color = "orange"
            }
            else if(reflectivity >= 75 && reflectivity <= 100)
            {
                rectSweat.color = "red"
            }

            rectHeart.width = heartRate;
            if(heartRate < 25)
            {
                rectHeart.color = "blue"
            }
            else if(heartRate >= 25 && heartRate < 50)
            {
                rectHeart.color = "green"
            }
            else if(heartRate >= 50 && heartRate < 75)
            {
                rectHeart.color = "orange"
            }
            else if(heartRate >= 75 && heartRate <= 100)
            {
                rectHeart.color = "red"
            }

            rectOxygen.width = sp02;
            if(sp02 < 25)
            {
                rectOxygen.color = "blue"
            }
            else if(sp02 >= 25 && sp02 < 50)
            {
                rectOxygen.color = "green"
            }
            else if(sp02 >= 50 && sp02 < 75)
            {
                rectOxygen.color = "orange"
            }
            else if(sp02 >= 75 && sp02 <= 100)
            {
                rectOxygen.color = "red"
            }

            recthHealth.width = health;
            if(health < 25)
            {
                recthHealth.color = "blue"
            }
            else if(health >= 25 && health < 50)
            {
                recthHealth.color = "green"
            }
            else if(health >= 50 && health < 75)
            {
                recthHealth.color = "orange"
            }
            else if(health >= 75 && health <= 100)
            {
                recthHealth.color = "red"
            }

            rectExpo.width = exposure;
            if(exposure < 25)
            {
                rectExpo.color = "blue"
            }
            else if(exposure >= 25 && exposure < 50)
            {
                rectExpo.color = "green"
            }
            else if(exposure >= 50 && exposure < 75)
            {
                rectExpo.color = "orange"
            }
            else if(exposure >= 75 && exposure <= 100)
            {
                rectExpo.color = "red"
            }

            imageRectImg.source = "file:/home/epilog/pictures/rgb/"+path+".jpg";
            imageRectBttmImg.source = "file:/home/epilog/pictures/ir/"+path+".jpg";

            capturedData.visible = true;
            streaming.visible = false;

            timerCaptured.start();
        }
    }

    Rectangle {
        id:streaming
        objectName: "streaming"
        width: parent.width
        height: parent.height
        //z:40
        color: "black"
        visible: true

	       MediaPlayer {
            	id: player

           	source: gstPipeline

            	//source: "gst-pipeline: videotestsrc ! qtvideosink"
            	//source: "gst-pipeline: playbin uri=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm"
            	//source: "gst-pipeline: nvarguscamerasrc ! autovideoconvert ! qtvideosink"
            	//source: "file:///home/jnano/Desktop/build-VideoOutput-Desktop-Release/file_example_WEBM_480_900KB.webm"
            	//source: "file:///home/ulas/Desktop/file_example_WEBM_1920_3_7MB.webm"
            	//source: "file:///home/epilog/ebt-ui/video.avi"
            	autoPlay: true
        
                onErrorChanged: {
                        console.log("MediaPlayer error ",errorString)

                }
               onStatusChanged:{
			console.log("status ",status)
                        if(status !== MediaPlayer.EndOfMedia)
                        {
                                if(flagScreen === false)
				{
					flagScreen = true
					timerSource.start()
                                }
				if(status == 0)
                                {
                                        console.log("media satatus: No Media")
                                }
                                else if(status == 1)
                                {
                                        console.log("media satatus: The Media is currently being loaded")
                                }
                                else if(status == 2)
                                {
                                        console.log("media satatus: The media has been loaded")
                                }
                                else if(status == 3)
                                {
                                        console.log("media satatus: The Media has buffering data")
                                }
                                else if(status == 4)
                                {
                                        console.log("media satatus: The playback has been interrupted while the media is buffering data")
                                }
                                else if(status == 5)
                                {
                                        console.log("media satatus: The Media has buffered data")
                                }
                                else if(status == 7)
                                {
                                        console.log("media satatus: The media can not be played")
                                }
                                else if(status == 8)
                                {
                                        console.log("media satatus: The status of media is unknown")
                                }

                        }
                        else
                        {
                                console.log("end of media")
			}	
               }


	}

        VideoOutput {
            id: videoOutput
            source: player
            anchors.fill: parent
        }

        signal qmlSignal()

        TapHandler{
            onTapped: {
                if(stackViewRect.visible === false)
                {
                    if(!password.visible || (password.opacity === 0))
                        streaming.qmlSignal();
                }

            }
        }

    }

    Rectangle {
        id: settings
        objectName: "settings"
        width: 100*resWidth
        height: 100*resHeight
        color:"transparent"
        Image
        {
            source:"../images/settings.png"
            anchors.fill: parent
            opacity: 0.6
            sourceSize.width: 100*resWidth
            sourceSize.height: 100*resHeight
        }

        y: windowMain.height - height -10
        x: windowMain.width - width - 30
        visible: true
        z:99;



        TapHandler{
            onTapped: {
                settings.visible = false;
                if(stackViewRect.visible === false)
                {
                    password.visible = true;
                    password.opacity = 1.0
                    password.z = 90;
                    streaming.z = -1;
                    passTextField.visible = true;
                    back.visible = true;
                    }
            }
        }
    }

    // If QtQuick.Controls 1.4 needed to control transition for stackview then Flickable does not work same as QtQuick.Controls 2.3.
    Flickable
    {
        id: flickable
        objectName: "passwordFli"
        anchors.fill: parent
        //anchors.bottomMargin: inputPanel.visible ? inputPanel.height : anchors.margins
        contentWidth: password.implicitWidth
        contentHeight: password.implicitHeight
        flickableDirection: Flickable.VerticalFlick



        Rectangle
        {
            id:password
            objectName: "password"
            width: parent.width*resWidth
            height: parent.height*resHeight
            color: "transparent"
            visible: false
            z: -1;

            Rectangle
            {
                id: title
                y: 14
                color: "blue"
                width: windowMain.width
                height: 40*resHeight
                z:99

                Rectangle
                {
                    id:back
                    objectName: "back"
                    width: 65 //39*resWidth
                    height: 39*resHeight
                    anchors.right: parent.right
                    color:"transparent"

                        Image
                        {
                        id: backImage
                        source:"../images/back.png"
                        fillMode:  Image.PreserveAspectFit
                        anchors.fill: parent
                        sourceSize.width: 39*resWidth
                        sourceSize.height: 39*resHeight
                        }

                        ColorOverlay{
                            anchors.fill:backImage
                            source: backImage
                            color: "#ffffff"
                        }

                        signal qmlSignalPass()
                        TapHandler{
                            onTapped: {

                                settings.visible = true;

                                password.opacity = 0;
                                password.z = -2;
                                passTextField.visible = false;
                                streaming.z = 30
                                //password.visible = false; // this do not work because of parent child relationship
                                //so visibility shoul be handled by z and opacity property
                                //back.qmlSignalPass(); // same as above, c++ part do not handle
                            }
                        }
                }

                Text
                {
                    text:"PIN"
                    font.family: "Helvetica"
                    font.pixelSize: 32 * resWidth
                    color: "white"
                    y:(title.height/2 - font.pixelSize/2)
                    x:(title.width/2 - font.pixelSize/2)

                }

            }

            TapHandler{
                onTapped: {
                    inputPanel.visible = false;
                    passTextField.focus = false;
                }
            }




                TextField {
                    id: passTextField
                    objectName: "passTextField"
                    width: 300*resWidth
                    height: 40*resHeight
                    y:windowMain.height/2
                    x:(windowMain.width/2 - width/2)
                    placeholderText: "Enter PIN"
                    echoMode: TextInput.Password
		    font.pointSize: 8
                    //https://bugreports.qt.io/browse/QTBUG-85694
                    //because TapHandler bug it is need to change not only visible property also with z value
                    onEditingFinished :
                    {
                        if( passTextField.text === "1234") // dummy password this will handle in C++ for hardware
                        {
                            stackViewRect.visible = true
                            stackViewRect.opacity = 1;
                            stackViewRect.z = 40;
                            password.opacity = 0;
                            password.z = -1;
                            passTextField.visible = false;
                            passTextField.text = "";
                            back.visible = false;
                            grid.visible = true;
                            //editingFinished() signal will be signalled automatically
                        }
                    }

                    onActiveFocusChanged: {
                        if(activeFocus)
                        {
                            inputPanel.visible = activeFocus
                            //var posWithinFlicable = mapToItem(password,0, height/2);
                            //flickable.contentY = posWithinFlicable.y - flickable.height/2;
                        }
                    }
                }

        }

    }

        Rectangle
        {
            id: stackViewRect
            objectName: "stackViewRect"
            width: parent.width
            height: parent.height
            color:"transparent"
            visible: false

          Rectangle{
              width: parent.width
              height: parent.height
              color:"white"
              opacity: 0.3
          }


          Rectangle
          {
              id: titleSettings
              y: 14
              color: "blue"
              width: parent.width
              height: 30
              z:33

              Rectangle
              {
                  id:backSettings
                  objectName: "backImage"
                  width: 65
                  height: 30
                  anchors.right: parent.right
                  color:"transparent"
                  enabled: true


                      Image
                      {
                      //source:"qrc:/back.png"
                      //source:"file:/home/jnano/Downloads/back.png"
                      //source:"file:/home/ulas/Desktop/back.png"
                      id: backImageSec
                      source:"../images/back.png"
                      fillMode:  Image.PreserveAspectFit
                      anchors.fill: parent
                      sourceSize.width: 30
                      sourceSize.height: 30
                      }

                      ColorOverlay{
                          anchors.fill:backImageSec
                          source: backImageSec
                          color: "#ffffff"
                      }

                      TapHandler{
                          onTapped: {
                              if(stackView.depth === 1)
                              {
                                    stackViewRect.opacity = 0;
                                    stackViewRect.z = -1;
                                    //stackViewRect.visible = true;
                                    streaming.z = 30
                                    grid.visible = false;
                                    stackViewRect.visible = false;
                                    settings.visible = true;
                              }
                              else
                              {
                                    stackView.pop();
                                    titleSett.text = "SETTINGS"
                              }
                                console.log(stackView.depth)
                              //passTextField.visible = false;
                              //password.visible = false; // this do not work because of parent child relationship
                              //so visibility shoul be handled by z and opacity property
                              //back.qmlSignalPass(); // same as above, c++ part do not handle
                          }
                      }
              }
          }

          Text
          {
              text:"SETTINGS"
              id: titleSett
              y : 18
              objectName: "settingsText"
              font.family: "Helvetica"
              font.pixelSize: 18
              color: "white"
              //anchors.top: titleSettings.top
              //anchors.bottom: titleSettings.bottom
              anchors.horizontalCenter: parent.horizontalCenter
              z:33
              opacity: 100
              onTextChanged:
              {

                    const str = titleSett.text;
                    if(titleSett.text === 'Configuring device please wait ....')
                    {
                        anim.running = true;
                    }
                    else if(titleSett.text === 'Connecting...' ||
                            titleSett.text === 'Not able to connect. Check router status or password.' ||
                            titleSett.text === "Disconnecting..." ||
                            titleSett.text === "WIFI Disconnected..." ||
                            titleSett.text === "Database is loading ...." ||
                            titleSett.text === "WIFI Disconnected..."
                            )
                    {
                        anim.running = true;
                    }
                    else if(titleSett.text === 'Scanning Network.....')
                    {
                        anim.running = true;
                    }
                    else if(str.includes("Starting"))
                    {
                        anim.running = true;
                    }
                    else
                    {
                      anim.running = false;
                      titleSett.opacity = 100
                    }
              }

              OpacityAnimator {
                  target: titleSett;
                  id: anim
                  objectName: ""
                  loops: Animation.Infinite
                  easing.type: Easing.OutCirc;
                  from: 0;
                  to: 1;
                  duration: 2000
                  running: false
              }
          }

            Rectangle{
                id: stackViewRect2

                width: parent.width
                height: parent.height
                color:"transparent"
                //opacity: 0.3
                y: 40
                z: 30
               // objectName: "pageModel"
                  ListModel {
                        id: pageModel
                        objectName: "pageModel2"
                          ListElement {
                              title: "ETHERNET"
                              page: "network.qml"
                              objectName: "networK"
                          }
                          ListElement {
                              title: "WIFI"
                              page: "Wifi.qml"
                          }
                          ListElement {
                              title: "USERS"
                              page: "Admin.qml"
                          }
                          ListElement {
                              title: "NOTIFICATIONS"
                              page: "Alarm.qml"
                          }
                          ListElement {
                              title: "SYSTEM"
                              page: "Local.qml"
                          }
                          ListElement {
                              title: "APP"
                              page: "hotspot.qml"
                          }

                  }


            StackView {
                id: stackView

                anchors.fill: parent
                // Implements back key navigation
                focus: true


                Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                                     stackView.pop();
                                     event.accepted = true;
                                 }



                    initialItem: Item {

                        Component {
                            id: contactDelegate
                            Item {
                                y: 30
                                width: grid.cellWidth; height: grid.cellHeight
                                Column {
                                    anchors.fill: parent
                                    Image {
                                        width: parent.width/1.72
                                        height: parent.height/1.56
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.verticalCenter: parent.verticalCenter
                                        source:"../images/"+title+".png";
                                    }
                                    Text {
                                        text: title;
                                        color: "white"
                                        font.pixelSize: (parent.width / parent.height) * 12.8
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.bottom: parent.bottom
                                    }
                                    Rectangle {
                                        anchors.fill: parent
                                        color: "#e6e6e6"
                                        radius: 20
                                        visible: mouse.pressed
                                        opacity: 0.3
                                    }
                                    TapHandler {
                                        id: mouse
                                        //anchors.fill: parent
                                        onTapped: {
                                            titleSett.text = title
                                            stackView.push(Qt.resolvedUrl(page))

                                        }


                                    }
                                }

                            }
                        }

                        GridView {
                            id: grid
                            anchors.fill: parent
                            cellWidth: parent.width/3.0
                            cellHeight: parent.height/2.6
                            width: parent.width/6
                            height: parent.height/5
                            model: pageModel
                            delegate: contactDelegate
                        }
                    }

            }
        }

        }

        Item{
            id: keyVis
            objectName: "keyVis"
            property bool keyFlag : false
            signal sendVis(bool flag, int width);
        }
        // for keyboard
        InputPanel {
            id: inputPanel
            z: 99
            x: 0
            y: windowMain.height
            width: windowMain.width

            onActiveChanged:
            {
                keyVis.keyFlag = keyVis.keyFlag ? false : true
                keyVis.sendVis(keyVis.keyFlag, inputPanel.y);
		if(keyVis.keyFlag === true)
                {
                      flickable.contentY = 50
                }
                else
                {
                      flickable.contentY = 0
                }
	
            }

            states: State {
                name: "visible"
                when: inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    y: windowMain.height - inputPanel.height
                }
            }
            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }

        }

}
