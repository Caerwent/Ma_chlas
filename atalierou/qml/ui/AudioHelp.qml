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

    ColoredImage {
        anchors.fill: parent
        id: help
        source: "qrc:///res/icons/help.svg"
        width: parent.witdh
        height: parent.height
        MouseArea {
            anchors.fill: parent
            enabled:audioHelp.clickable
            onClicked: {
                helpMediaPlayer.play()
            }
        }
    }


    MediaPlayer {
        id: helpMediaPlayer
        audioOutput: AudioOutput {

        }
        onPlaybackStateChanged: {
            var temp

            switch (playbackState)
            {
            case MediaPlayer.PlayingState:
                temp = "MediaPlayer.PlayingState"
                audioStart()
                break;

            case MediaPlayer.PausedState:
                temp = "MediaPlayer.PausedState"
                break;

            case MediaPlayer.StoppedState:
                temp = "MediaPlayer.StoppedState"
                 audioEnded()
                break;
            //console.log(temp)
            }
        }

    }

    onAudioFileChanged: {
        helpMediaPlayer.source =Qt.resolvedUrl(audioFile);
    }
}
