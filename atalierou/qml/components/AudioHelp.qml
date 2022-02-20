import QtQuick
import QtQuick.Controls
import QtMultimedia
import UIUtils 1.0 as UIUtils
import "."
import ".."
import "../dataModels"

Item {
    id:audioHelp

    property var audioFile
    property bool clickable:true
    property alias playbackState:helpMediaPlayer.playbackState

    signal audioEnded
    signal audioStart

    function play() {
        helpMediaPlayer.play()
    }
    Accessible.role: Accessible.Button
    Accessible.name: qsTr("accessible.help.clickToListen")
    Accessible.onPressAction: {
        play()
    }
    ColoredImage {
        Accessible.ignored: true
        anchors.fill: parent
        id: help
        source: "qrc:///res/icons/help.svg"
        width: parent.witdh
        height: parent.height
        MouseArea {
            anchors.fill: parent
            enabled:audioHelp.clickable
            onClicked: {
                play()
            }
        }
    }


    MediaPlayer {
        id: helpMediaPlayer
        audioOutput: AudioOutput {

        }
        onPlaybackStateChanged: {

            switch (playbackState)
            {
            case MediaPlayer.PlayingState:
                //console.log("MediaPlayer.PlayingState")
                audioStart()
                break;

            case MediaPlayer.PausedState:
                //console.log("MediaPlayer.PausedState")
                break;

            case MediaPlayer.StoppedState:
                //console.log("MediaPlayer.StoppedState")
                 audioEnded()
                break;

            }
        }
        onMediaStatusChanged: {
            switch (mediaStatus)
            {
            case MediaPlayer.NoMedia:
                console.log("MediaPlayer.NoMedia")
                audioStart()
                break;


            case MediaPlayer.LoadingMedia:
                console.log("MediaPlayer.LoadingMedia")
                break;

            case MediaPlayer.LoadedMedia:
                console.log("MediaPlayer.LoadedMedia")
                break;

            case MediaPlayer.BufferingMedia:
                console.log("MediaPlayer.BufferingMedia")

                break;
            case MediaPlayer.BufferingMedia:
                console.log("MediaPlayer.BufferingMedia")
                break;

            case MediaPlayer.StalledMedia:
                console.log("MediaPlayer.StalledMedia")
                break;

            case MediaPlayer.BufferingMedia:
                //console.log("MediaPlayer.BufferingMedia")
                break;

            case MediaPlayer.BufferedMedia:
                console.log("MediaPlayer.BufferedMedia")
                break;
            case MediaPlayer.EndOfMedia:
                console.log("MediaPlayer.EndOfMedia")
                break;
            case MediaPlayer.InvalidMedia:
                console.log("MediaPlayer.InvalidMedia")
                break;
            }
        }

    }

    onAudioFileChanged: {
        helpMediaPlayer.source =Qt.resolvedUrl(audioFile);
    }
}
