import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Dialogs
import UIUtils 1.0 as UIUtils
import "../../main"
import "../../dataModels"
import "../../components"

Flow {
    id:corpusItem
    flow:Flow.TopToBottom
    spacing: 20*UIUtils.UI.dp
    anchors.margins: 10*UIUtils.UI.dp


    required property var selectedCorpusItem
    required property var selectedCorpusIndex

    property alias needToBeSave :dataModel.needToBeSaved

    property var fileOpenDialog: FileDialog {

        modality: Qt.WindowModal
        fileMode: FileDialog.OpenFile
        title: qsTr("Choose audio file")
        nameFilters: [ qsTr("Audio files (*.mp3 *.ogg *.wav)"), qsTr("All files (*)")]

        onAccepted: {
            dataModel.soundFileToPlay = selectedFile
            dataModel.corpusSoundText = MakerSession.corpus.getFilenameRelativeToPath(dataModel.soundFileToPlay)

            dataModel.needToBeSaved = (dataModel.corpusSoundText!== (selectedCorpusItem?(selectedCorpusItem.sound?selectedCorpusItem.sound:""):""))
            if(dataModel.needToBeSaved)
            {
                 selectedCorpusItem.sound=dataModel.corpusSoundText
            }

            dataModel.playCorpusSoundEnabled = true

        }
    }
    onSelectedCorpusItemChanged:
    {
        dataModel.needToBeSaved = false
        dataModel.corpusSoundText=selectedCorpusItem? (selectedCorpusItem.sound?selectedCorpusItem.sound:""):""
        dataModel.soundFileToPlay = selectedCorpusItem? (selectedCorpusItem.sound?("file://"+MakerSession.corpus.getPathAbsolute() + selectedCorpusItem.sound):""):""
        dataModel.playCorpusSoundEnabled=selectedCorpusItem? (selectedCorpusItem.sound?true:false):false

        dataModel.corpusIdText=selectedCorpusItem? (selectedCorpusItem.corpusId?selectedCorpusItem.corpusId:"") : ""
        dataModel.checkCorpusIdIsValid(dataModel.corpusIdText)

        dataModel.corpusImageText = selectedCorpusItem? (selectedCorpusItem.image?selectedCorpusItem.image:""):""
        dataModel.imageToDisplay = selectedCorpusItem? (selectedCorpusItem.image?("file://"+MakerSession.corpus.getPathAbsolute() + selectedCorpusItem.image):""):""
        dataModel.imageToDisplayVisible = !isBlank(dataModel.imageToDisplay)

        nbSyllabesSpinBox.value = selectedCorpusItem? (selectedCorpusItem.nbSyllabes?selectedCorpusItem.nbSyllabes:1):1

        fileOpenDialog.currentFolder = MakerSession.corpus? ("file://"+MakerSession.corpus.getPathAbsolute()):""
    }


    function isBlank(str) {
        return (!str || /^\s*$/.test(str));
    }
    QtObject {
        id:dataModel

        property bool corpusIdErrorVisible :false
        property bool playCorpusSoundEnabled :false
        property bool needToBeSaved : false

        property string soundFileToPlay:""
        property string corpusSoundText:""
        property string imageToDisplay:""
        property bool imageToDisplayVisible:false
        property string corpusImageText:""
        property string corpusIdText:""

        function nbSyllabesChanged(input)
        {
            if(input>0 && input <=15)
            {
                if(selectedCorpusItem!==undefined && selectedCorpusItem.nbSyllabes!==input)
                {
                    selectedCorpusItem.nbSyllabes = input
                    needToBeSaved = true
                 }



            }
        }

        function checkCorpusIdIsValid(input){

            if (isBlank(input)) {
                corpusIdErrorVisible= true
            }
            else {

                var items = MakerSession.corpus.getItems()
                var idAlreadyUsed = false
                for(var i=0;i<items.length;i++)
                {
                    if(selectedCorpusIndex!==i && items[i].corpusId===input)
                    {
                        idAlreadyUsed=true
                        break
                    }
                }
                corpusIdErrorVisible= idAlreadyUsed
                if(!corpusIdErrorVisible)
                {
                    if(input!== selectedCorpusItem.corpusId)
                    {
                        needToBeSaved = true
                        selectedCorpusItem.corpusId=input
                    }
                }

            }

        }
    }




            Label {
                text: qsTr("MakerCorpusEdit.corpusId.label")
                font.pixelSize: 14
                font.bold: true
            }

            TextField {
                id: corpusId
                text:dataModel.corpusIdText
                font.pixelSize: 12
                placeholderText: qsTr("MakerCorpusEdit.corpusId.hint")
                color:Material.primaryTextColor
                onEditingFinished: {
                    dataModel.checkCorpusIdIsValid(text)

                }
            }
            Label {
                text: qsTr("MakerCorpusEdit.corpusId.error")
                color: Material.accentColor
                visible: dataModel.corpusIdErrorVisible
                font.pixelSize: 12
                font.bold: true
            }


            Label {
                text: qsTr("MakerCorpusEdit.image.label")
                font.pixelSize: 14
                font.bold: true
            }

            Label {
                id: corpusImg
                text:dataModel.corpusImageText
                font.pixelSize: 12
            }
            Image {
                                        id: corpusImgVisual
                                        width:60*UIUtils.UI.dp
                                        height:60*UIUtils.UI.dp
                                        source:dataModel.imageToDisplay
                                        sourceSize: Qt.size(width, height)
                                        anchors.margins: 10*UIUtils.UI.dp
                                        visible:dataModel.imageToDisplayVisible
                                        Accessible.ignored: true
                                    }

            Label {
                text: qsTr("MakerCorpusEdit.sound.label")
                font.pixelSize: 14
                font.bold: true
            }

            Flow {
                spacing: 20*UIUtils.UI.dp

                ColoredImage {
                    id:playIcon
                    source: "qrc:/res/icons/action_play.svg"
                    width: 40*UIUtils.UI.dp
                    height: 40*UIUtils.UI.dp
                    visible:dataModel.playCorpusSoundEnabled
                    Accessible.ignored: true
                    RotationAnimator {
                        id:rotatingPlay
                            target: playIcon
                            from: 0
                            to: 360
                            loops: Animation.Infinite
                            duration: 1000
                            running: false
                            alwaysRunToEnd:true
                        }
                    MouseArea {
                        anchors.fill: parent
                        enabled:dataModel.playCorpusSoundEnabled
                        onClicked: {
                            mediaPlayer.play()
                        }
                    }
                    Accessible.role:Accessible.Button
                    Accessible.name: qsTr("accessible.clickToListen")

                }
                MediaPlayer {

                    id: mediaPlayer
                    source:dataModel.soundFileToPlay
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

                    function startSound() {
                        rotatingPlay.start()
                    }
                    function stopSound() {
                        rotatingPlay.stop()
                    }

                }

                Text {
                    id: corpusSound
                    text:dataModel.corpusSoundText
                    font.pixelSize: 12
                    color:Material.primaryTextColor
                }

            }
            Button {
                text: qsTr("MakerCorpusEdit.audioFile.open")
                onClicked: {
                    fileOpenDialog.open()
                }

            }
            Label {
                text: qsTr("MakerCorpusEdit.nbSyllabes.label")
                font.pixelSize: 14
                font.bold: true
            }
            SpinBox {
                id:nbSyllabesSpinBox
                from:1
                to:15
               onValueChanged: {
                   dataModel.nbSyllabesChanged(value)
               }

            }
        }



