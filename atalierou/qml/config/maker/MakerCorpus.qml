import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Dialogs
import UIUtils 1.0 as UIUtils
import "../../main"
import "../../dataModels"
import "../../components"

ScreenTemplate {

    titleText: qsTr("MakerCorpus.title")

    property var fileOpenDialog: FileDialog {

        modality: Qt.WindowModal
        fileMode: FileDialog.OpenFile
        title: qsTr("Choose a corpus file")
        nameFilters: [ qsTr("Json files (*.json)")]

        onAccepted: {
            MakerSession.corpus.read(selectedFile)
            corpusEditor.fileOpenDialog.currentFolder= MakerSession.corpus.path? MakerSession.corpus.getPathAbsolute():""
            imageOpenDialog.currentFolder= MakerSession.corpus.path? MakerSession.corpus.getPathAbsolute():""
        }
    }
    property var fileSaveDialog: FileDialog {

        modality: Qt.WindowModal
        fileMode: FileDialog.SaveFile
        title: qsTr("Choose new corpus file")
        nameFilters: [ qsTr("Json files (*.json)")]

        onAccepted: {
            MakerSession.corpus.saveAs(selectedFile,".")
            corpusEditor.fileOpenDialog.currentFolder= MakerSession.corpus.path? MakerSession.corpus.getPathAbsolute():""
            imageOpenDialog.currentFolder= MakerSession.corpus.path? MakerSession.corpus.getPathAbsolute():""
        }
    }
    property var imageOpenDialog: FileDialog {

        modality: Qt.WindowModal
        fileMode: FileDialog.OpenFiles
        title: qsTr("Choose corpus image files")
        nameFilters: [ qsTr("Image files (*.jpg *.png)"), qsTr("All files (*)") ]

        onAccepted: {

            dataModel.addImages(selectedFiles)
        }
    }


    function isBlank(str) {
        return (!str || /^\s*$/.test(str));
    }
    AppScrollView {
        id:screen
    Rectangle {
        id:screenContent
        border.color :"transparent"
        color:Material.backgroundColor
        anchors.fill: parent
        QtObject {
            id:dataModel
            property string newBtnText: qsTr("Maker.File.new")
            property bool newBtnTextVisibility: MakerSession.mode===MakerSession.Mode.NewCorpus
            property string selectedFileTxt:""

            property int selectedCorpusIndex:0
            property bool addCorpusEnabled:false
            property bool editOrRemoveCorpusEnabled:false

            property int lastSelectedIndex:-1

            property bool corpusNeedToBeSaved : false

            function doSave()
            {
                dataModel.lastSelectedIndex = corpusList.currentIndex
                if(isBlank(MakerSession.corpus.filename))
                    fileSaveDialog.open()
                else
                    MakerSession.corpus.save()
                corpusEditor.needToBeSave = false
                dataModel.corpusNeedToBeSaved = false

            }

            function addImages(imagesFiles)
            {
                for(var i=0;i<imagesFiles.length; i++)
                {

                    var newItem = Qt.createQmlObject('import QtQuick; import Corpus 1.0; CorpusItem {}', parent);
                    newItem.image = MakerSession.corpus.getFilenameRelativeToPath(imagesFiles[i])
                    newItem.corpusId = newItem.image.slice(newItem.image.lastIndexOf("/")+1)
                    newItem.corpusId = newItem.corpusId.substring(0, newItem.corpusId.lastIndexOf('.')) || newItem.corpusId

                    var nbAlreadyUsed = 0
                    var items = MakerSession.corpus.getItems()
                    for(var idx=0;idx<items.length;idx++)
                    {
                        if(items[idx]===newItem.corpusId )
                        {
                            nbAlreadyUsed++
                        }
                    }
                    if(nbAlreadyUsed>0)
                    {
                        newItem.corpusId = newItem.corpusId+"_"+nbAlreadyUsed
                    }

                    MakerSession.corpus.addItem(newItem)
                    dataModel.corpusNeedToBeSaved=true
                }

            }

        }
        Connections {
            target: MakerSession.corpus
            function onFilenameChanged(filename) {
                //console.log("corpus: onFilenameChanged")
                if(isBlank(MakerSession.corpus.filename))
                {
                    dataModel.newBtnText= qsTr("Maker.corpus.new")
                    dataModel.selectedFileTxt = ""
                    dataModel.addCorpusEnabled=false
                }
                else
                {
                    dataModel.newBtnText= qsTr("Maker.File.save")
                    dataModel.selectedFileTxt=MakerSession.corpus.filename
                    dataModel.addCorpusEnabled=true

                }

                if(MakerSession.mode===MakerSession.Mode.EditCorpus)
                {
                    dataModel.newBtnTextVisibility = !isBlank(MakerSession.corpus.filename)
                }
                else if(MakerSession.mode===MakerSession.Mode.NewCorpus)
                {
                    dataModel.newBtnTextVisibility=true
                }
            }

            function onItemsChanged(){
                corpusListModel.clear()
                // console.log("corpus: onItemsChanged")
                var list = MakerSession.corpus.getItems()
                if(list!==undefined)
                {
                    for(var i=0;i<list.length;i++)
                    {
                        corpusListModel.append({
                                                   idx:i,
                                                   corpus:list[i],
                                                   needToBeSave:false
                                               })
                    }
                }
                if(dataModel.lastSelectedIndex>0 && dataModel.lastSelectedIndex<list.length)
                {
                    corpusList.currentIndex=dataModel.lastSelectedIndex
                }
            }
        }
        Flow {
            id:corpusFile
            anchors.top:parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            flow:Flow.TopToBottom
            spacing: 20*UIUtils.UI.dp
            Label {
                text: qsTr("MakerCorpus.corpusFile.label")
                font.pixelSize: 14
                font.bold: true
            }
            Text {
                id: corpusFileSelected
                text:dataModel.selectedFileTxt
                font.pixelSize: 12
                color:Material.primaryTextColor
            }
            Button {
                anchors.leftMargin: 20*UIUtils.UI.dp
                text: qsTr("MakerCorpus.corpusFile.open")
                visible: MakerSession.mode===MakerSession.Mode.EditCorpus
                onClicked: {
                    fileOpenDialog.open()
                }

            }
            Row {
                visible: dataModel.newBtnTextVisibility
                spacing: 10*UIUtils.UI.dp
                Button {
                    id:saveBtn
                    bottomInset :0
                    topInset:0
                    text: dataModel.newBtnText
                    onClicked: {
                        dataModel.doSave()
                    }

                }

                ColoredImage {
                    id:modifiedIcon
                    source: "qrc:/res/icons/action_edit.svg"
                    width: 30*UIUtils.UI.dp
                    height: 30*UIUtils.UI.dp
                    opacity:dataModel.corpusNeedToBeSaved ? 1 : 0
                    overlayColor: Material.accentColor
                }



            }


        }

        Label {
            id:corpusListLabel
            text: qsTr("MakerCorpus.corpusList.label")
            font.pixelSize: 14
            font.bold: true
            anchors.topMargin: 20*UIUtils.UI.dp
            anchors.top:corpusFile.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }
        Flow {
            id:corpusListActions
            anchors.top:corpusListLabel.bottom
            anchors.left: parent.left
            spacing: 5*UIUtils.UI.dp
            anchors.topMargin: 20*UIUtils.UI.dp
            flow:Flow.LeftToRight
            ColoredImage {
                source: "qrc:/res/icons/action_add.svg"
                width: 20*UIUtils.UI.dp
                height: 20*UIUtils.UI.dp
                enabled:dataModel.addCorpusEnabled

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        imageOpenDialog.open()
                    }
                }
                Accessible.role: Accessible.Button
                Accessible.name: qsTr("accessible.add")
                Accessible.onPressAction: {
                    imageOpenDialog.open()
                }

            }
            ColoredImage {
                source: "qrc:/res/icons/action_remove.svg"
                width: 20*UIUtils.UI.dp
                height: 20*UIUtils.UI.dp
                enabled:dataModel.editOrRemoveCorpusEnabled

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        MakerSession.corpus.removeItemAt(corpusList.currentIndex)
                        corpusList.currentIndex = -1
                        dataModel.corpusNeedToBeSaved=true
                    }
                }
                Accessible.role: Accessible.Button
                Accessible.name: qsTr("accessible.remove")
                Accessible.onPressAction: {
                    MakerSession.corpus.removeItemAt(corpusList.currentIndex)
                    corpusList.currentIndex = -1
                    dataModel.corpusNeedToBeSaved=true
                }

            }

        }

        ListModel {
            id:corpusListModel
        }
        Row {
            id:corpusListPanel
            anchors.topMargin: 20*UIUtils.UI.dp
            anchors.top:corpusListActions.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom:parent.bottom
            ListView {
                id:corpusList
                width: parent.width/2
                height: parent.height
                model: corpusListModel
                delegate: Row {
                    property bool isCurrentItem : ListView.isCurrentItem
                    ColoredImage {
                        id:modifiedIconItem
                        source: "qrc:/res/icons/action_edit.svg"
                        width: 10*UIUtils.UI.dp
                        height: 10*UIUtils.UI.dp
                        opacity:needToBeSave ? 1 : 0
                        overlayColor: Material.accentColor
                    }
                    Text{
                        id:eltText
                        text: corpus.corpusId
                        color: isCurrentItem ? Material.textSelectionColor : Material.primaryTextColor
                        MouseArea {
                            anchors.fill: parent
                            onClicked: corpusList.currentIndex = index
                        }
                    }


                }

                onCurrentIndexChanged: {
                    dataModel.editOrRemoveCorpusEnabled = (currentItem!==undefined && dataModel.addCorpusEnabled)
                    corpusEditor.selectedCorpusIndex = currentIndex
                    corpusEditor.selectedCorpusItem = corpusListModel.get(currentIndex).corpus

                }
            }

            ScrollView {
                id:scrollView
                width: parent.width/2
                height: parent.height
                visible: dataModel.editOrRemoveCorpusEnabled
                clip: true


                ScrollBar.vertical: ScrollBar {
                    id:scrollBar
                    policy: ScrollBar.AsNeeded
                    height: scrollView.height
                    width: 10*UIUtils.UI.dp
                    x:scrollView.width-width

                }
                Keys.onUpPressed: scrollBar.decrease()
                Keys.onDownPressed: scrollBar.increase()



                MakerCorpusEdit {
                    id:corpusEditor
                    width: parent.width

                    selectedCorpusItem: undefined
                    selectedCorpusIndex:-1
                    onNeedToBeSaveChanged: {
                        if(corpusEditor.needToBeSave && corpusListModel.count>corpusEditor.selectedCorpusIndex && corpusEditor.selectedCorpusIndex>=0){
                            corpusListModel.get(corpusEditor.selectedCorpusIndex).needToBeSave=true
                            dataModel.corpusNeedToBeSaved=true
                        }
                    }

                }

            }
        }

}

    }
}

