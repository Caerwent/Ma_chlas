import QtQuick
import QtQuick.Controls
import QtMultimedia
import UIUtils 1.0 as UIUtils
import "."
import "../../dataModels"

Item {
    id:countPhonems

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

        property int currentIndex
        property int currentLevelIndex
        property var syllabe





                Image {
                    id: img
                    width: 250*UIUtils.UI.dp
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    sourceSize: Qt.size(width, height)

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
                    }
                }



                Flow {
                    flow: Flow.LeftToRight
                    anchors.margins: 10*UIUtils.UI.dp
                    anchors.top: img.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10*UIUtils.UI.dp
                    Repeater {
                        id:counterRepeater
                        model : syllabe.max
                        Image {
                            width: 50*UIUtils.UI.dp
                            height: 50*UIUtils.UI.dp

                            source:"qrc:///res/icons/count"+(index+1)+".svg"
                            sourceSize: Qt.size(width, height)

                        }
                    }






        }

        onSyllabeChanged: {
            img.source = Qt.resolvedUrl(Session.activityPath+syllabe.image);
            img.sourceSize= Qt.size(img.width, img.height)
            //https://www.qt.io/product/qt6/qml-book/ch11-multimedia-playing-media
            mediaPlayer.source =Qt.resolvedUrl(Session.activityPath+syllabe.sound);

        }

        onCurrentIndexChanged: {
            syllabe = Session.selectedActivities[currentLevelIndex].items[currentIndex]
        }

        onCurrentLevelIndexChanged:
        {
            currentIndex = 0
        }

        Component.onCompleted:
        {
            childrenFrame.currentLevelIndex=0
            currentIndex = 0
            syllabe = Session.selectedActivities[currentLevelIndex].items[currentIndex]
            counterRepeater.model = syllabe.max
        }
    }
}
