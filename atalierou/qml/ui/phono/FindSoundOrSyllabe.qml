import QtQuick
import QtQuick.Controls
import QtMultimedia
import UIUtils 1.0 as UIUtils
import "."
import ".."
import "../../dataModels"

Item {
    id:findSoundOrSyllabe
    property int currentIndex
    property int currentLevelIndex: Session.activityIndex
    property var currentItem

    property int respGridWith: syllabe.max*60*UIUtils.UI.dp
    property int respGridheight: syllabe.max*60*UIUtils.UI.dp

    property bool itemDone : false
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
        text: qsTr("Find sound or syllabe")
        anchors.topMargin: 20*UIUtils.UI.dp
        anchors.leftMargin: 20*UIUtils.UI.dp
        anchors.rightMargin: 20*UIUtils.UI.dp
        font.pointSize: 20
    }
    Rectangle {

        id:contentFrame
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
            id:scoreBar
            border.color :"transparent"
            color:Material.backgroundColor
            width: 100*UIUtils.UI.dp
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            AudioHelp {

                id: help
                audioFile:Session.activityAudioHelp
                width: 60*UIUtils.UI.dp
                height: 60*UIUtils.UI.dp
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                onAudioEnded: {
                    helpComp.play()
                }
                onAudioStart: {
                    startSound()
                }

            }
            AudioHelp {
                visible:false
                clickable:false
                id: helpComp
                anchors.top: help.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onAudioStart: {
                    startSound()
                }
                onAudioEnded: {
                    stopSound()
                }
            }

            Image {
                id: playSoundIndicator
                width: 60*UIUtils.UI.dp
                height: 60*UIUtils.UI.dp
                anchors.top: helpComp.bottom
                anchors.topMargin: 10*UIUtils.UI.dp
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:///res/icons/listen.svg"
                sourceSize: Qt.size(width, height)
                //antialiasing: true
                smooth: true
                opacity: 0
            }

         GaugeImage {
             id:gauge
             width: 80*UIUtils.UI.dp
             height: 190*UIUtils.UI.dp
             anchors.top: playSoundIndicator.bottom
             anchors.topMargin: 40*UIUtils.UI.dp
             anchors.horizontalCenter: parent.horizontalCenter
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
            height: 250*UIUtils.UI.dp
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30*UIUtils.UI.dp
            anchors.leftMargin: 30*UIUtils.UI.dp
            fillMode: Image.PreserveAspectFit

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
                    case MediaPlayer.PlayingState:
                        temp = "MediaPlayer.PlayingState"
                        startSound()
                        break;

                    case MediaPlayer.PausedState:
                        temp = "MediaPlayer.PausedState"
                        break;

                    case MediaPlayer.StoppedState:
                        temp = "MediaPlayer.StoppedState"
                         stopSound()
                        break;
                    //console.log(temp)
                    }
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
                    Rectangle {
                        border.color :Material.accentColor
                        color:Material.foreground
                        width: 50*UIUtils.UI.dp
                        height: 50*UIUtils.UI.dp
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
                        to: gauge.y
                        duration: 400
                    }
                    NumberAnimation {
                        target: star
                        properties: "x"
                        to: gauge.x+gauge.width/2
                        duration: 400
                    }

                    onStopped: {
                        star.visible=false
                        star.x=check.x+check.width+10*UIUtils.UI.dp
                        star.y=check.y
                        score++
                        scorePercent=score*100/items.length
                        gotToNextItem()
                    }
                }


        }



    }
    }

    function startSound()
    {
        playSoundIndicator.opacity=1
    }

    function stopSound()
    {
        if(mediaPlayer.playbackState!==MediaPlayer.PlayingState &&
                help.playbackState!==MediaPlayer.PlayingState &&
                helpComp.playbackState!==MediaPlayer.PlayingState)
        {
            playSoundIndicator.opacity=0
        }
    }


    onCurrentItemChanged: {
        img.source = Qt.resolvedUrl(Session.activityPath+currentItem.image)
        img.sourceSize= Qt.size(img.width, img.height)
        mediaPlayer.source =Qt.resolvedUrl(Session.activityPath+currentItem.sound)
        helpComp.audioFile = Qt.resolvedUrl(Session.activityPath+currentItem.helpFile)
        helpComp.play()

    }

    Component.onCompleted:
    {
        items = Session.getShuffleRandomItems()
        changeIndex(0)
    }

    function changeIndex(index)
    {
        currentIndex = index
        currentItem = items[currentIndex]
        responsesModel.clear()
        for (var i = 0; i < currentItem.max; i++)
        {

            responsesModel.append({
                                      indexValue:i,
                                      checkVisibility:false,
                                      isValid:false,
                                      wrongResp:false
                                  })
        }
        respGridWith= currentItem.max*response.cellWidth
        respGridheight= ((currentItem.max/(currentItem.max*response.cellWidth)) + 1 )*response.cellHeight

    }

    function clickResult(indexValue)
    {
        if(!itemDone)
        {
            responsesModel.get(indexValue).checkVisibility= ! responsesModel.get(indexValue).checkVisibility
            var nothingChecked=true
            for (var i = 0; i<responsesModel.count; i++)
            {
                if(responsesModel.get(i).checkVisibility===true)
                {
                    nothingChecked=false
                    break
                }
            }

            checkEnabled=!nothingChecked
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

            if(itemDone)
            {
                check.source="qrc:///res/icons/eye.svg"
                itemDone=false
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

                itemDone=true
                check.source="qrc:///res/icons/next.svg"
                var atLeastOneError = false;
                for (var i = 0; i<responsesModel.count; i++)
                {
                    if(responsesModel.get(i).checkVisibility)
                    {
                        if(currentItem.value.includes((i+1)))
                        {
                            responsesModel.get(i).isValid=true
                        }
                        else
                        {
                            responsesModel.get(i).checkVisibility=false
                            responsesModel.get(i).wrongResp=true
                            atLeastOneError=true
                        }
                    }
                    else if(currentItem.value.includes((i+1)))
                    {
                        responsesModel.get(i).checkVisibility=true
                        atLeastOneError=true
                    }
                }
                if(!atLeastOneError)
                {
                    star.visible=true
                }
            }
        }
    }
}
