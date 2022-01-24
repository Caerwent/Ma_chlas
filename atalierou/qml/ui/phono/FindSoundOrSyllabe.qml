import QtQuick
import QtQuick.Controls
import QtMultimedia
import UIUtils 1.0 as UIUtils
import "."
import ".."
import "../../dataModels"

Item {
    id:findSoundOrSyllabe


    FindSoundOrSyllabeModel {
        id:itemModel

        onEnded: {
            App.instance.getNavigator().gotToScreen(Screens.score)
        }

        onStartStarAnimation: {
            startAnim.restart()
        }

        onAudioHelpCompSourceChanged: {
            helpComp.audioFile=itemModel.audioHelpCompSource
            helpComp.play()
        }

        onCurrentItemChanged: {
            response.width= itemModel.currentItem.max*response.cellWidth
            response.height= ((itemModel.currentItem.max/(itemModel.currentItem.max*response.cellWidth)) + 1 )*response.cellHeight
        }

    }

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
                audioFile:itemModel.audioHelpSource
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
                fillPercent: itemModel.scorePercent
                source: "qrc:///res/icons/starGauge.svg"
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
                source: itemModel.imageSource
                sourceSize: Qt.size(img.width, img.height)
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
                    source:itemModel.audioSource
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
                                itemModel.clickResult(indexValue)
                            }
                        }
                    }
                }
            }
            GridView {
                id: response
                cellWidth: 60*UIUtils.UI.dp
                cellHeight: 60*UIUtils.UI.dp

                anchors.margins: 10*UIUtils.UI.dp
                anchors.top: img.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                flow:GridView.FlowLeftToRight
                model: itemModel.responsesModel
                delegate: responsesModelDelegate
            }
            ColoredImage {
                id: check
                width: 50*UIUtils.UI.dp
                height: 50*UIUtils.UI.dp
                anchors.top: response.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:///res/icons/eye.svg"
                enabled: itemModel.checkEnabled
                onClicked:{
                    itemModel.checkResult()
                }
            }
            ColoredImage {
                id: star
                width: 50*UIUtils.UI.dp
                height: 50*UIUtils.UI.dp
                x:check.x+check.width+10*UIUtils.UI.dp
                y:check.y
                visible: itemModel.starVisibility
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
                        itemModel.starVisibility=false
                        star.x=check.x+check.width+10*UIUtils.UI.dp
                        star.y=check.y
                        itemModel.incrScore()
                        itemModel.gotToNextItem()
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

    Component.onCompleted:
    {
        itemModel.init()
    }
}
