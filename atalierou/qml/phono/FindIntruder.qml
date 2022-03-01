import QtQuick
import QtQuick.Controls
import QtMultimedia
import UIUtils 1.0 as UIUtils
import "../main"
import "../components"
import "../dataModels"


ScreenTemplate {
    id:countPhonems

    titleText: qsTr("FindIntruder.title")

    FindIntruderModel {
        id:itemModel

        onEnded: {
            App.instance.getNavigator().gotToScreen(Screens.score)
        }

        onStartStarAnimation: {
            startAnim.restart()
        }

        property int nbMediaPlaying:0

        onNbMediaPlayingChanged:
        {
            if(nbMediaPlaying>0)
                playSoundIndicator.opacity=1
            else
                playSoundIndicator.opacity=0

        }

    }

    AppScrollView {
        id:screen
        anchors.fill: parent
        anchors.topMargin: 20*UIUtils.UI.dp
        ScrollBar.horizontal :  ScrollBar {

                                   policy: ScrollBar.AlwaysOff


                               }

        Rectangle {
            id:scrollContent
            /*anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right*/
            width:parent.width

            Rectangle {
                id:scoreBar
                border.color :"transparent"
                color:Material.backgroundColor
                width: 100*UIUtils.UI.dp
                anchors.top: parent.top
                anchors.left: parent.left

                AudioHelp {
                    id: help
                    audioFile:itemModel.audioHelpSource
                    width: 60*UIUtils.UI.dp
                    height: 60*UIUtils.UI.dp
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    onAudioEnded: {
                        stopSound()
                    }
                    onAudioStart: {
                        startSound()
                    }

                }

                Image {
                    id: playSoundIndicator
                    width: 60*UIUtils.UI.dp
                    height: 60*UIUtils.UI.dp
                    anchors.top: help.bottom
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
                id:responseFrame
                anchors.top: parent.top
                anchors.left: scoreBar.right
                anchors.right: parent.right
                border.color :"transparent"
                color:Material.backgroundColor


                state : App.instance.state
                states: [
                    State {
                        name: "landscape"
                        PropertyChanges {
                            target: response
                             flow: Flow.LeftToRight
                        }
                    },
                    State {
                        name: "portrait"
                        PropertyChanges {
                            target: response
                             flow: Flow.TopToBottom
                        }
                    }
                ]

                Component {
                    id:responsesModelDelegate
                    Rectangle {
                        id:item
                        border.color :"transparent"
                        color:"transparent"
                        state : App.instance.state
                        states: [
                            State {
                                name: "landscape"
                                PropertyChanges {
                                    target: item
                                    width: 100*UIUtils.UI.dp
                                    height: 160*UIUtils.UI.dp
                                }
                                AnchorChanges {
                                    target: coche
                                     anchors.top:img.bottom
                                     anchors.left: undefined
                                     anchors.horizontalCenter: parent.horizontalCenter
                                     anchors.verticalCenter: undefined
                                }
                            },
                            State {
                                name: "portrait"
                                PropertyChanges {
                                    target: item
                                    width: 160*UIUtils.UI.dp
                                    height: 100*UIUtils.UI.dp
                                }
                                AnchorChanges {
                                    target: coche
                                    anchors.top:undefined
                                    anchors.left: img.right
                                    anchors.horizontalCenter: undefined
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        ]
                        Image {
                            id: img
                            width: 100*UIUtils.UI.dp
                            height: 100*UIUtils.UI.dp
                            anchors.top:parent.top
                            anchors.left:parent.left
                            source: image
                            sourceSize: Qt.size(img.width, img.height)
                            fillMode: Image.PreserveAspectFit

                            ColoredImage {
                                id: listenOverlay
                                anchors.fill: parent
                                anchors.margins: 10*UIUtils.UI.dp
                                source: "qrc:///res/icons/listen.svg"
                                overlayColor: Material.accentColor
                                visible:false

                            }
                            MediaPlayer {
                                id: mediaPlayer

                                source:audio
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
                        Rectangle {
                            id:coche
                            width: 50*UIUtils.UI.dp
                            height: 50*UIUtils.UI.dp
                            anchors.margins: 10*UIUtils.UI.dp
                            border.color :"transparent"
                            color:"transparent"

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


                Flow {
                    id: response
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.margins: 10*UIUtils.UI.dp
                    anchors.top: parent.top

                    spacing: 20*UIUtils.UI.dp

                    onHeightChanged: {
                        screen.contentHeight = Math.max(height+check.height+check.anchors.topMargin, scoreBar.height)
                    }

                    Repeater {
                        model:itemModel.responsesModel
                        delegate: responsesModelDelegate
                    }
                }




                ColoredImage {
                    id: check
                    width: 50*UIUtils.UI.dp
                    height: 50*UIUtils.UI.dp
                    anchors.top: response.bottom
                    anchors.topMargin: 20*UIUtils.UI.dp
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
                            to: gauge.y-responseFrame.y
                            duration: 400
                        }
                        NumberAnimation {
                            target: star
                            properties: "x"
                            to: gauge.x+gauge.width/2 -responseFrame.x
                            duration: 400
                        }

                        onStopped: {
                            //star.visible=false
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


    }
    function startSound()
    {
        itemModel.nbMediaPlaying++

    }

    function stopSound()
    {
        itemModel.nbMediaPlaying--

    }

    Component.onCompleted:
    {
        itemModel.init()
    }


}
