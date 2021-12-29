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
    signal audioEnded

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
                audioEnded()
                break;

            case MediaPlayer.InvalidMedia:
                temp = "MediaPlayer.InvalidMedia"
                break;

            case MediaPlayer.UnknownStatus:
                temp = "MediaPlayer.UnknownStatus"
                break;
            }

            console.log(temp)
        }

    }

    onAudioFileChanged: {
        helpMediaPlayer.source =Qt.resolvedUrl(audioFile);
    }
}
