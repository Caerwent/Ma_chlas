import QtQuick
import QtMultimedia

Item {
    id: item
    width: 200; height: 200

    property variant dataPath
    property variant phonemData

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

    Image {id: img
        MouseArea {
               id: playArea
               anchors.fill: parent
               onPressed: mediaPlayer.play();
           }
    }



    onPhonemDataChanged: {
        img.source = Qt.resolvedUrl("file://"+dataPath+phonemData.image);
        //https://www.qt.io/product/qt6/qml-book/ch11-multimedia-playing-media
        mediaPlayer.source =Qt.resolvedUrl("file://"+dataPath+phonemData.sound);

    }
}
