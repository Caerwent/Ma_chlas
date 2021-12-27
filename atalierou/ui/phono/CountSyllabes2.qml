import QtQuick
import QtQuick.Controls
import QtMultimedia
import UIUtils 1.0 as UIUtils
import "."
import ".."
import "../../dataModels"

Item {
    id:countPhonems
    property int currentIndex
    property int currentLevelIndex: Session.activityIndex
    property var syllabe

    property int respGridWith: syllabe.max*60*UIUtils.UI.dp
    property int respGridheight: syllabe.max*60*UIUtils.UI.dp

    property bool syllabeDone : false
    property bool checkEnabled : false

    property int score : 0
    property real scorePercent : 0

    property var items
    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        id: title
        text: qsTr("Count syllabes")
        anchors.topMargin: 20*UIUtils.UI.dp
        anchors.leftMargin: 20*UIUtils.UI.dp
        anchors.rightMargin: 20*UIUtils.UI.dp
        font.pointSize: 20
    }
    Rectangle {

        id:childrenFrame
        anchors.top: title.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 40*UIUtils.UI.dp
        anchors.topMargin: 40*UIUtils.UI.dp
        anchors.rightMargin: 40*UIUtils.UI.dp
        anchors.bottomMargin: 40*UIUtils.UI.dp
        border.color :"transparent"
        color:Material.backgroundColor


        Rectangle {
            border.color :"transparent"
            color:Material.backgroundColor
            id:scoreBar
            width: 80*UIUtils.UI.dp
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            AudioHelp {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10*UIUtils.UI.dp
                id: help
                audioFile:Session.activityAudioHelp
                width: 60*UIUtils.UI.dp
                height: 60*UIUtils.UI.dp

            }

         GaugeImage {
             width: 80*UIUtils.UI.dp
             height: 160*UIUtils.UI.dp
             anchors.horizontalCenter: parent.horizontalCenter
              anchors.verticalCenter: parent.verticalCenter
             overlayEmptyColor: Material.backgroundDimColor
             overlayFullColor: "#ED8A19"
             fillPercent: scorePercent
             source: "qrc:///res/icons/starGauge.svg"
             hoverEnabled: false
         }

        }

        Rectangle {
            anchors.top: parent.top
            anchors.left: scoreBar.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            border.color :"transparent"
            color:Material.backgroundColor
        Image {
            id: img
            width: 250*UIUtils.UI.dp
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30*UIUtils.UI.dp
            anchors.leftMargin: 30*UIUtils.UI.dp
            sourceSize: Qt.size(width, height)

            ColoredImage {
                id: listenOverlay
                visible:false
                anchors.fill: parent
                anchors.margins: 10*UIUtils.UI.dp
                source: "qrc:///res/icons/listen.svg"
    overlayColor: Material.accentColor

            }
            MediaPlayer {
                id: mediaPlayer
                audioOutput: AudioOutput {

                }
                onPlaybackStateChanged: {
                    var temp

                    switch (playbackState)
                    {
                    case MediaPlayer.NoMedia:
                        temp = "MediaPlayer.NoMedia"
                        break;

                    case MediaPlayer.Loading:
                        temp = "MediaPlayer.Loading"
                        break;

                    case MediaPlayer.Loaded:
                        temp = "MediaPlayer.Loaded"
                        break;

                    case MediaPlayer.Buffering:
                        temp = "MediaPlayer.Buffering"
                        break;

                    case MediaPlayer.Stalled:
                        temp = "MediaPlayer.Stalled"
                        break;

                    case MediaPlayer.Buffered:
                        temp = "MediaPlayer.Buffered"
                        break;

                    case MediaPlayer.EndOfMedia:
                        temp = "MediaPlayer.EndOfMedia"
                        break;

                    case MediaPlayer.InvalidMedia:
                        temp = "MediaPlayer.InvalidMedia"
                        break;

                    case MediaPlayer.UnknownStatus:
                        temp = "MediaPlayer.UnknownStatus"
                        break;
                    }

                    console.log(temp)

                    /* if (playbackState === MediaPlayer.Loaded)
                                    {
                                        play()
                                    }*/
                }

            }

            MouseArea {
                id: playArea
                anchors.fill: parent
                onPressed: mediaPlayer.play();
                hoverEnabled: true
                onEntered:{
                    listenOverlay.visible=true
                }

                onExited :{
                    listenOverlay.visible=false
                }
            }
        }


        ListModel {
            id:responsesModel
        }

        Component {
            id:responsesModelDelegate
            Rectangle {
                width: 60*UIUtils.UI.dp
                height: 60*UIUtils.UI.dp
                border.color :"transparent"
                color:"transparent"
                Rectangle {
                    width: 50*UIUtils.UI.dp
                    height: 50*UIUtils.UI.dp
                    border.color :"transparent"
                    color:"transparent"
                    anchors.centerIn: parent
                    Image {
                        width: 50*UIUtils.UI.dp
                        height: 50*UIUtils.UI.dp

                        source:imgSrc
                        sourceSize: Qt.size(width, height)

                    }
                    ColoredImage {
                        id:resultMark
                        width: 40*UIUtils.UI.dp
                        height: 40*UIUtils.UI.dp
                        anchors.centerIn: parent
                        overlayColor: isValid ? "#00FF00": "#000000"
                        visible:checkVisibility
                        hoverEnabled:false
                        source:"qrc:///res/icons/ok.svg"

                    }
                    Image {
                        id:errorMark
                        width: 40*UIUtils.UI.dp
                        height: 40*UIUtils.UI.dp
                        anchors.centerIn: parent
                        source:"qrc:///res/icons/wrong.svg"
                        sourceSize: Qt.size(width, height)
                        smooth: true
                        visible: wrongResp
                    }
                    MouseArea {
                        anchors.fill: parent
                        onPressed:
                        {
                            clickResult(indexValue)
                        }
                    }
                }
            }
        }


        GridView {
            id: response
            width:respGridWith
            height:respGridheight
            anchors.margins: 10*UIUtils.UI.dp
            anchors.top: img.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            cellWidth: 60*UIUtils.UI.dp; cellHeight: 60*UIUtils.UI.dp
            flow:GridView.FlowLeftToRight
            model: responsesModel
            delegate: responsesModelDelegate
        }





        ColoredImage {
            id: check
            width: 50*UIUtils.UI.dp
            height: 50*UIUtils.UI.dp
            anchors.top: response.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:///res/icons/eye.svg"
            enabled: checkEnabled
            onClicked:{
                checkResult()
            }
        }
        ColoredImage {
            id: star
            width: 50*UIUtils.UI.dp
            height: 50*UIUtils.UI.dp
            x:check.x+check.width+10*UIUtils.UI.dp
            y:check.y
            visible: false
            overlayColor: "#ED8A19"
            hoverEnabled:false
            source: "qrc:///res/icons/star.svg"
            ParallelAnimation {
                    id: startAnim
                    NumberAnimation {
                        target: star
                        properties: "y"
                        to: scoreBar.y+scoreBar.height/2
                        duration: 400
                    }
                    NumberAnimation {
                        target: star
                        properties: "x"
                        to: scoreBar.x+scoreBar.width/2
                        duration: 400
                    }

                    onStopped: {
                        star.visible=false
                        star.x=check.x+check.width+10*UIUtils.UI.dp
                        star.y=check.y
                        score++
                        scorePercent=score*100/Session.selectedActivities[currentLevelIndex].items.length
                        gotToNextItem()
                    }
                }


        }



    }
    }

    onSyllabeChanged: {
        img.source = Qt.resolvedUrl(Session.activityPath+syllabe.image);
        img.sourceSize= Qt.size(img.width, img.height)
        //https://www.qt.io/product/qt6/qml-book/ch11-multimedia-playing-media
        mediaPlayer.source =Qt.resolvedUrl(Session.activityPath+syllabe.sound);

    }

    Component.onCompleted:
    {
        items = Session.getShuffleRandomItems()
        changeIndex(0)
    }

    function changeIndex(index)
    {
        currentIndex = index
        syllabe = items[currentIndex]
        responsesModel.clear()
        for (var i = 0; i < syllabe.max; i++)
        {

            responsesModel.append({
                                      indexValue:i,
                                      imgSrc:"qrc:///res/icons/count"+(i+1)+".svg",
                                      checkVisibility:false,
                                      isValid:false,
                                      wrongResp:false
                                  })
        }
        respGridWith= syllabe.max*response.cellWidth
        respGridheight= ((syllabe.max/(syllabe.max*response.cellWidth)) + 1 )*response.cellHeight

    }

    function clickResult(indexValue)
    {
        if(!syllabeDone)
        {
        for (var i = 0; i<responsesModel.count; i++)
        {
            responsesModel.get(i).checkVisibility=(i===indexValue)
        }
        checkEnabled=true
        }
    }


    function gotToNextItem()
    {
        if(currentIndex<(items.length-1))
        {
            changeIndex(currentIndex+1)
        }
        else
        {
            Session.addScore(scorePercent)
            Session.exerciceScore=scorePercent
            App.instance.getNavigator().gotToScreen(Screens.score)

        }

    }

    function checkResult()
    {
        console.log("checkResult")
        if(checkEnabled)
        {

            if(syllabeDone)
            {
                check.source="qrc:///res/icons/eye.svg"
                syllabeDone=false
                checkEnabled=false

                if(star.visible===true)
                {
                    startAnim.restart()
                } else {
                    gotToNextItem()
                }

            }
            else
            {

                syllabeDone=true
                check.source="qrc:///res/icons/next.svg"
                for (var i = 0; i<responsesModel.count; i++)
                {
                    if(responsesModel.get(i).checkVisibility)
                    {
                        if(i===syllabe.value)
                        {
                            responsesModel.get(i).isValid=true
                            star.visible=true
                        }
                        else
                        {
                            responsesModel.get(i).checkVisibility=false
                            responsesModel.get(i).wrongResp=true
                        }
                    }
                    else if(i===syllabe.value)
                    {
                        responsesModel.get(i).checkVisibility=true
                    }
                }
            }
        }
    }
}
