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
                              page: "network.qml"
                          }
                          ListElement {
                              title: "USERS"
                              page: "network.qml"
                          }
                          ListElement {
                              title: "NOTIFICATIONS"
                              page: "network.qml"
                          }
                          ListElement {
                              title: "SYSTEM"
                              page: "network.qml"
                          }
                          ListElement {
                              title: "APP"
                              page: "network.qml"
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
