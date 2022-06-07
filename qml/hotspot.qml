import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.12
import com.ulasdikme.hotspot 1.0

Item {

    width: parent.width
    height: parent.height
    visible: true
    id: hotspotSettings

    property double iter : 0;
    property int xHeartRate: 0;
    property int yHeartRate: 0;
    property int heartRate: 0
    property string heartRateColor: "blue"

    property int bodyTempValue: 0
    property string bodyTempTemp : "blue"

    property int spo2Val: 0
    property string spo2ValColor: "blue"

    property int sweatVal: 0
    property string sweatValColor: "blue"

    property int healthVal: 0
    property string healthValColor: "blue"

    property int exposureVal: 0
    property string exposureValColor: "blue"

    Component.onCompleted: {

        //console.log(hotspotObj.lengthOfList);
    }

    Hotspot
    {
        id: hotspotObj

        onLengthOfListChanged:
        {

         }

        onUpdateChanged:
        {
            //console.log("update is happened");

            //console.log(hotspotObj.lengthOfList);
            //for(var i = 0; i < hotspotObj.lengthOfList; i++)
            //for(var i = 0; i < 5; i++)
            //{
            var heartvalue = 0;
            var heartRateColorTemp = "blue";

            var bodyTemp = "blue"
            var bodyTempratureValue = 0;

            var spo2Val = 0;
            var spo2ValColor = "blue";

            var sweatValTmp = 0;
            var sweatValColorTmp = "blue";

            var healthValTmp = 0;
            var healthValColorTmp = "blue";

            var exposureValTmp = 0;
            var exposureValColorTmp = "blue";


            if(hotspotObj.heartRate[iter] < 35)
            {
                heartvalue = 0;
            }
            else if(hotspotObj.heartRate[iter] > 220)
            {
                heartvalue = 100;
            }
            else
            {
                heartvalue = ((100*heartRate[iter] / 185)-(700/37))
            }

            if(heartvalue < 25)
            {
                heartRateColorTemp = "blue"
            }
            else if(heartvalue >= 25 && heartvalue < 50)
            {
                heartRateColorTemp = "green"
            }
            else if(heartvalue >= 50 && heartvalue < 75)
            {
                heartRateColorTemp = "orange"
            }
            else if(heartvalue >= 75 && heartvalue < 100)
            {
                heartRateColorTemp = "red"
            }
            //heartvalue = heartvalue *2;



            if(hotspotObj.bodyTemprature[iter] < 34)
            {
                bodyTempratureValue = 0;
            }
            else if(hotspotObj.bodyTemprature[iter] > 41)
            {
                bodyTempratureValue = 100;
            }
            else
            {
                bodyTempratureValue =((100*hotspotObj.bodyTemprature[iter])/3)-((100*34)/3)
            }

            if(bodyTempratureValue < 50)
            {
                bodyTemp = "blue"
            }
            else if(bodyTempratureValue >= 50 && bodyTempratureValue < 100)
            {
                bodyTemp = "green"
            }
            else if(bodyTempratureValue >= 100 && bodyTempratureValue < 150)
            {
                bodyTemp = "orange"
            }
            else if(bodyTempratureValue >= 150 && bodyTempratureValue <= 200)
            {
                bodyTemp = "red"
            }
            bodyTempratureValue = bodyTempratureValue / 2;

            if(hotspotObj.sp02[iter] < 90)
            {
                spo2Val = 0;
            }
            else if(hotspotObj.sp02[iter] > 100)
            {
                spo2Val = 200;
            }
            else
            {
                spo2Val = (100-hotspotObj.sp02[iter]) * 20;
            }

            if(spo2Val < 50)
            {
                spo2ValColor = "blue"
            }
            else if(spo2Val >= 50 && spo2Val < 100)
            {
                spo2ValColor = "green"
            }
            else if(spo2Val >= 100 && spo2Val < 150)
            {
                spo2ValColor = "orange"
            }
            else if(spo2Val >= 150 && spo2Val <= 200)
            {
                spo2ValColor = "red"
            }
            spo2Val = spo2Val / 2;


            if(hotspotObj.reflectivity[iter] < 0)
            {
                sweatValTmp = 0;
            }
            else if(hotspotObj.reflectivity[iter] > 100)
            {
                sweatValTmp = 200;
            }
            else
            {
                sweatValTmp = (hotspotObj.reflectivity[iter]) * 2;
            }

            if(sweatValTmp < 50)
            {
                sweatValColorTmp = "blue"
            }
            else if(sweatValTmp >= 50 && sweatValTmp < 100)
            {
                sweatValColorTmp = "green"
            }
            else if(sweatValTmp >= 100 && sweatValTmp < 150)
            {
                sweatValColorTmp = "orange"
            }
            else if(sweatValTmp >= 150 && sweatValTmp <= 200)
            {
                sweatValColorTmp = "red"
            }
            sweatValTmp = sweatValTmp /2;


            if(hotspotObj.health[iter] < 0)
            {
                healthValTmp = 0;
            }
            else if(hotspotObj.health[iter] > 100)
            {
                healthValTmp = 200;
            }
            else
            {
                healthValTmp = (hotspotObj.health[iter]) * 2;
            }

            if(healthValTmp < 50)
            {
                healthValColorTmp = "blue"
            }
            else if(healthValTmp >= 50 && healthValTmp < 100)
            {
                healthValColorTmp = "green"
            }
            else if(healthValTmp >= 100 && healthValTmp < 150)
            {
                healthValColorTmp = "orange"
            }
            else if(healthValTmp >= 150 && healthValTmp <= 200)
            {
                healthValColorTmp = "red"
            }
            healthValTmp = healthValTmp / 2;

            if(hotspotObj.exposure[iter] < 0)
            {
                exposureValTmp = 0;
            }
            else if(hotspotObj.exposure[iter] > 100)
            {
                exposureValTmp = 200;
            }
            else
            {
                exposureValTmp = (hotspotObj.exposure[iter]) * 2;
            }

            if(exposureValTmp < 50)
            {
                exposureValColorTmp = "blue"
            }
            else if(exposureValTmp >= 50 && exposureValTmp < 100)
            {
                exposureValColorTmp = "green"
            }
            else if(exposureValTmp >= 100 && exposureValTmp < 150)
            {
                exposureValColorTmp = "orange"
            }
            else if(exposureValTmp >= 150 && exposureValTmp <= 200)
            {
                exposureValColorTmp = "red"
            }
            exposureValTmp = exposureValTmp / 2;

                slider.model.append({textUpdate:"first name: "
                                        +hotspotObj.firstName[iter]+"\n"
                                        +"second name: "
                                        +hotspotObj.secName[iter]+"\n"
                                        +"time: "
                                        +hotspotObj.time[iter]+"\n"
                                        +"date: "
                                        +hotspotObj.date[iter]+"\n"
                                        +"room temp: "
                                        +hotspotObj.roomTemp[iter]+"\n"
                                        +"room hum: "
                                        +hotspotObj.roomHum[iter]+"\n"
                                        +"birth date: "
                                        +hotspotObj.birthDate[iter]+"\n"
                                        +"license: "
                                        +hotspotObj.licenseNumber[iter]+"\n"
                                        +"tracking id: "
                                        +hotspotObj.trackingId[iter]+"\n"
                                        +"body temp: "
                                        +hotspotObj.bodyTemprature[iter]+"\n"
                                        +"reflectivity: "
                                        +hotspotObj.reflectivity[iter]+"\n"
                                        +"heart rate: "
                                        +hotspotObj.heartRate[iter]+"\n"
                                        +"breathing rate: "
                                        +hotspotObj.breathingRate[iter]+"\n"
                                        +"sp02: "
                                        +hotspotObj.sp02[iter]+"\n"
                                        +"health: "
                                        +hotspotObj.health[iter]+"\n"
                                        +"exposure: "
                                        +hotspotObj.exposure[iter]+"\n"
                                        +"weight: "
                                        +hotspotObj.weight[iter]+"\n"
                                        +"height: "
                                        +hotspotObj.height[iter]+"\n"
                                        +"age: "
                                        +hotspotObj.age[iter]+"\n"
                                        +"sex: "
                                        +hotspotObj.sex[iter]+"\n"
                                        +"race: "
                                        +hotspotObj.race[iter]+"\n"
                                        +"mood: "
                                        +hotspotObj.mood[iter]+"\n"
                                        +"pose: "
                                        +hotspotObj.pose[iter]+"\n"
                                        +"clothing: "
                                        +hotspotObj.clothing[iter]+"\n"
                                        +"face: "
                                        +hotspotObj.face[iter]+"\n"
                                        ,
                                        image:"file:/home/epilog/pictures/rgb/"+hotspotObj.photo[iter]+".jpg",
                                        image2:"file:/home/epilog/pictures/ir/"+hotspotObj.photo[iter]+".jpg",
                                        heartRate:heartvalue,
                                        heartRateColor:heartRateColorTemp,
                                        bodyTempValue:bodyTempratureValue,
                                        bodyTempTemp:bodyTemp,
                                        spo2Val:spo2Val,
                                        spo2ValColor:spo2ValColor,
                                        sweatVal: sweatValTmp,
                                        sweatValColor:sweatValColorTmp,
                                        healthVal: healthValTmp,
                                        healthValColor: healthValColorTmp,
                                        exposureVal: exposureValTmp,
                                        exposureValColor: exposureValColorTmp,
                                    })



            //}
            iter = iter + 1;
        }
    }

    SwipeView{
       id:slider

       height: parent.height
       width: parent.width
       //x:(parent.width-width)/2//make item horizontally center
       property var model :ListModel{}
       clip:true
       Repeater {

           model:slider.model
           Rectangle {

               width: slider.width
               height: slider.height
               color: "transparent"

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
                   y: 20
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
                   y: 20
                   id: rectHeat;
                   width: bodyTempValue
                   height: 15
                   color: bodyTempTemp
                   opacity: 1
                   anchors.left: rectHeatText.right
                   z:99
               }

               Rectangle
               {
                   y: 20
                   id: rectHeatNeg;
                   width: 100-bodyTempValue
                   height: 15
                   color: "black"
                   opacity: 0.2
                   anchors.left: rectHeat.right;
                   z:99
               }



               // sweat
               Rectangle
               {
                   y: 50
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
                   y: 50
                   id: rectSweat;
                   width: sweatVal
                   height: 15
                   color: sweatValColor
                   opacity: 1
                   anchors.left: rectSweatText.right
                   z:99
               }

               Rectangle
               {
                   y: 50
                   id: rectSweatNeg;
                   width: 100-sweatVal
                   height: 15
                   color: "black"
                   opacity: 0.2
                   anchors.left: rectSweat.right;
                   z:99
               }




               //heart
               Rectangle
               {
                   y: 80
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
                   y: 80
                   id: rectHeart;
                   width: heartRate
                   height: 15
                   color: heartRateColor
                   opacity: 1
                   anchors.left: rectHeartText.right
                   z:99
               }

               Rectangle
               {
                   y: 80
                   id: rectHeartNeg;
                   width: 100 - heartRate
                   height: 15
                   color: "black"
                   opacity: 0.2
                   anchors.left: rectHeart.right;
                   z:99
               }



               //oxygen
               Rectangle
               {
                   y: 110
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
                   y: 110
                   id: rectOxygen
                   width: spo2Val
                   height: 15
                   color: spo2ValColor
                   opacity: 1
                   anchors.left: rectOxygenText.right
                   z:99
               }

               Rectangle
               {
                   y: 110
                   id: rectOxygenNeg;
                   width: 100 - spo2Val
                   height: 15
                   color: "black"
                   opacity: 0.2
                   anchors.left: rectOxygen.right;
                   z:99
               }




               //health
               Rectangle
               {
                   y: 140
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
                   y: 140
                   id: recthHealth
                   width: healthVal
                   height: 15
                   color: healthValColor
                   opacity: 1
                   anchors.left: rectHealthText.right
                   z:99
               }

               Rectangle
               {
                   y: 140
                   id: rectHealthNeg;
                   width: 100-healthVal
                   height: 15
                   color: "black"
                   opacity: 0.2
                   anchors.left: recthHealth.right;
                   z:99
               }

               //exposure
               Rectangle
               {
                   y: 170
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
                   y: 170
                   id: rectExpo
                   width: exposureVal
                   height: 15
                   color: exposureValColor
                   opacity: 1
                   anchors.left: exposureText.right
                   z:99
               }

               Rectangle
               {
                   y: 170
                   id: rectExpoNeg;
                   width: 100-exposureVal
                   height: 15
                   color: "black"
                   opacity: 0.2
                   anchors.left: rectExpo.right;
                   z:99
               }




//               Rectangle
//               {

//                   width: 200
//                   height: 200
//                   color: "transparent"
//                   opacity: 1
//                   anchors.right: parent.right
//                   anchors.top: parent.top
//                   //anchors.margins: 20 // Sets all margins at once

//                       Canvas {
//                           id: root
//                           // canvas size
//                           width: 200; height: 200
//                           // handler to override for drawing
//                           onPaint: {
//                               // get context to draw with
//                               var ctx = getContext("2d")
//                               // setup the stroke
//                               ctx.lineWidth = 4
//                               ctx.strokeStyle = "gray"
//                               // setup the fill
//                               ctx.fillStyle = "gray"
//                               // begin a new path to draw
//                               ctx.beginPath()
//                               // top-left start point
//                               ctx.moveTo(100,0)
//                               // upper line
//                               ctx.lineTo(200,80)
//                               ctx.lineTo(150,200)
//                               ctx.lineTo(50,200)
//                               ctx.lineTo(0,80)
//                               ctx.closePath()
//                               // fill using fill style
//                               ctx.fill()
//                               // stroke using line width and stroke style
//                               ctx.stroke()
//                           }
//                       }

//                   z:97
//                }

//               Rectangle
//               {

//                   width: 200
//                   height: 200
//                   color: "transparent"
//                   opacity: 1
//                   anchors.right: parent.right
//                   anchors.top: parent.top
//                   //anchors.margins: 20 // Sets all margins at once

//                       Canvas {
//                           id: canvas
//                           // canvas size
//                           width: 200; height: 200
//                           // handler to override for drawing
//                           onPaint: {
//                               // get context to draw with
//                               var ctx = getContext("2d")
//                               // setup the stroke
//                               ctx.lineWidth = 4
//                               ctx.strokeStyle = "red"
//                               // setup the fill
//                               ctx.fillStyle = "red"
//                               // begin a new path to draw
//                               ctx.beginPath()
//                               // top-left start point
//                               ctx.moveTo(100,20)
//                               // upper line
//                               ctx.lineTo(xHeartRate, yHeartRate) // heart rate position
//                               ctx.lineTo(125,150)
//                               ctx.lineTo(60,170)
//                               ctx.lineTo(25,80)
//                               ctx.closePath()
//                               // fill using fill style
//                               ctx.fill()
//                               // stroke using line width and stroke style
//                               ctx.stroke()
//                           }
//                       }

//                   z:99
//                }

//               Rectangle
//               {
//                   width: 180 //slider.width  / 2.66
//                   height: slider.height
//                   color: "transparent"
//                   opacity: 0.4

//                   z:99
//                }
//               ScrollView
//               {
//                   id: scroolView
//                   width: 180 //slider.width  / 2.66
//                   height: slider.height - 40
//                   ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
//                   ScrollBar.vertical.policy : ScrollBar.AlwaysOn

//                   z:99
//                   Text {
//                       width: slider.width
//                       height: slider.height
//                       id: name
//                       text: textUpdate
//                       font.family: "Helvetica"
//                       font.pointSize: 11
//                       //font.bold: true
//                       color: "black"
//                       z:99
//                   }
//                   padding:10
//                }

               Rectangle
               {

                   id: imageRect
                   width: 150
                   height: 180
                   anchors.fill: imageRect
                   anchors.left: hotspotSettings.right
                   anchors.topMargin: 8

                   //y: 25
                   //anchors.right: rightRect.left
		   color: "black"

                   Image{
                      width: imageRect.width
                      height: imageRect.height
                      source:image
                      fillMode: Image.Stretch
                   }
               }

               Rectangle
               {

                   id: imageRectBttm
                   width: 150
                   height: 150
                   anchors.fill: imageRecBttm
		   anchors.left: imageRect.right
                   anchors.right: rightRect.left
                   anchors.top : imageRect.top
                   //anchors.top: imageRect.bottom
                   anchors.bottom: imageRect.bottom
                   color: "white"

                   Image{
                      width: imageRectBttm.width
                      height: imageRectBttm.height
                      source:image2
                      fillMode: Image.Stretch
                   }
               }

           }

       }
    }
 //   PageIndicator {
 //      anchors.top: slider.bottom
 //      anchors.topMargin: verticalMargin
 //      x:(parent.width-width)/2
 //      currentIndex: slider.currentIndex
 //      count: slider.count
 //   }

//    Component.onCompleted:
//    {

//        if(!hotspotObj.disableWifi)
//        {   if(!hotspotObj.enableHot)
//            {
//                station.visible = true;
//                hotspotRec.visible = false;
//            }
//            else
//            {
//                station.visible = false;
//                hotspotRec.visible = true;
//            }
//        }
//        else
//        {
//            station.visible = false;
//            hotspotRec.visible = false;
//        }

//    }

//    Flickable {
//        id: flickable
//        anchors.fill: parent
//        width: 400; height: 400
//        contentWidth: parent.width; contentHeight: parent.height
//        //anchors.margins: 20
//        anchors.bottomMargin: hotspotObj.keyFlag ? (hotspotObj.keyWidth - 420) : 30
//        flickableDirection: Flickable.VerticalFlick

//            Rectangle
//            {
//                width: 400
//                height: 300
//                color:"transparent"
//                //anchors.top: parent.top
//                y : 15
//                anchors.horizontalCenter: parent.horizontalCenter
//                Text
//                {
//                    color: "green"
//                    font.pixelSize: 28
//                    font.weight: Font.DemiBold
//                    text: hotspotObj.disableWifi ? "" : hotspotObj.enableHot ? 'Update the ssid & password' : 'Temprature Face Detection'
//                 }
//            }

//            Hotspot
//            {
//                id: hotspotObj

//                onEnableHotChanged:
//                {
//                    if(!hotspotObj.enableHot)
//                    {
//                        enable.checked = false;
//                        enable.enabled = true;
//                        station.visible = true;
//                        hotspotRec.visible = false;
//                    }
//                    else
//                    {
//                        station.visible = false;
//                        hotspotRec.visible = true;
//                    }
//                }
//            }

//            Rectangle
//            {
//                id: station
//                width: 300
//                height: 180
//                y: 80
//                z:99
//                color: "transparent"
//                anchors.horizontalCenter: parent.horizontalCenter

//                CheckBox{
//                    //checked: true
//                    id: enable
//                    text : qsTr("Run the Covid Face Detection App")
//                    anchors.left: parent.left

//                    onCheckedChanged:
//                    {
//                        enabled = false
//                        if(checked)
//                        {
//                            hotspotObj.updateHotspot("EPILOG","epilog2021");
//                            console.log("checkbox is checked");
//                        }
//                    }
//                }


//            }



//           Rectangle
//           {

//            id: hotspotRec
//            width: 400
//            height: 180
//            y: 80
//            color: "transparent"
//            anchors.horizontalCenter: parent.horizontalCenter

//            TextField
//            {
//                id: hotspotSsid
//                width: 220
//                height: 30
//                y: 20
//                placeholderText: "Enter SSID"
//                echoMode: TextInput.Normal
//                anchors.horizontalCenter: parent.horizontalCenter

//                onActiveFocusChanged: {
//                    if(activeFocus)
//                    {
//                        //inputPanel.visible = activeFocus
//                        var posWithinFlicable = mapToItem(hotspotSettings,0, height/2);
//                        flickable.contentY = posWithinFlicable.y - flickable.height/2;
//                    }
//                }

//            }

//            TextField
//            {
//                id: hotspotpass
//                width: 220
//                height: 30
//                y: 60
//                placeholderText: "Enter Password"
//                echoMode: TextInput.Password
//                anchors.horizontalCenter: parent.horizontalCenter

//                onActiveFocusChanged: {
//                    if(activeFocus)
//                    {
//                        //inputPanel.visible = activeFocus
//                        var posWithinFlicable = mapToItem(hotspotSettings,0, height/2);
//                        flickable.contentY = posWithinFlicable.y - flickable.height/2;
//                    }
//                }
//            }

//            Button {

//                text: "Update"
//                //anchors.top : parent.bottom
//               // anchors.left: control.right;
//                //anchors.margins: 10
//                y : 100
//                anchors.right: hotspotpass.right
//                //anchors.topMargin: 40
//                //anchors.horizontalCenter: parent.horizontalCenter
//                background: Rectangle {
//                    implicitWidth: 90
//                    implicitHeight: 30
//                    border.width: hotspotpass.activeFocus ? 2 : 1
//                    border.color: "#888"
//                    radius: 4
//                    gradient: Gradient {
//                        GradientStop { position: 0 ; color: hotspotButton.pressed ? "#ccc" : "#eee" }
//                        GradientStop { position: 1 ; color: hotspotButton.pressed ? "#aaa" : "#ccc" }
//                    }
//                }
//                objectName: "hotspotButton"
//                signal hotspotButton()
//                id:hotspotButton
//                onClicked:
//                {
//                    //console.log("hotspotButton network is clicked");
//                    hotspotObj.updateHotspot(hotspotSsid.text, hotspotpass.text);
//                }
//            }
//           }
//    }// end of Flickable

}
