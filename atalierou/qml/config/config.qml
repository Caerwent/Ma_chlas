import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Dialogs
import UIUtils 1.0 as UIUtils
import "../main"
import "../components"
import "../dataModels"
import Qt.labs.folderlistmodel

ScreenTemplate {
    id:configurationComponent

    titleText: qsTr("Configuration")

    property var fileOpenDialog: FileDialog {

        modality: Qt.WindowModal
        title: qsTr("Choose a configuration file")
        nameFilters: [ qsTr("Json files (*.json)")]

        onAccepted: {
            console.log("selected: " + selectedFile)
            configFileTxtField.text=selectedFile
        }
    }

    AppScrollView {
        id:screen
        anchors.fill: parent
        anchors.topMargin: 20*UIUtils.UI.dp


        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 20*UIUtils.UI.dp
            CheckBox {
                id: checkBox
                text: qsTr("Use embedded configuration")

                onCheckedChanged: {
                    externalConfig.enabled=!checked
                }
            }
            Column {
                id:externalConfig
                width:parent.width

                Label {
                    text: qsTr("Use external configuration")
                }
                Flow {

                    spacing: 20*UIUtils.UI.dp
                    width:parent.width

                    Button {
                        id: configFileBtn
                        anchors.leftMargin: 20*UIUtils.UI.dp
                        text: qsTr("Open file...")
                        onClicked: {
                            fileOpenDialog.open()
                        }

                    }
                    TextField {
                        anchors.leftMargin: 20*UIUtils.UI.dp
                        width:parent.width-configFileBtn.width-40*UIUtils.UI.dp
                        id: configFileTxtField
                        placeholderText: qsTr("Enter a JSON configuration file")
                    }

                }
            }

            Flow {
                spacing: 20*UIUtils.UI.dp
                Label {
                    text: qsTr("Choose language")
                }
                ComboBox {
                    id: languageCombo
                    model: ["fr", "en", "br"]
                    currentIndex: model.indexOf(GlobalConfigModel.language)
                }
            }

            Button {
                text: qsTr("Apply")
                onClicked: {
                    GlobalConfigModel.isEmbedded=checkBox.checked
                    GlobalConfigModel.externalFile=configFileTxtField.text
                    GlobalConfigModel.language=languageCombo.currentValue
                    GlobalConfigModel.load()
                }
            }
            Button {
                id:classDetailsBtn
                text: qsTr("View class details")
                visible: !GlobalConfigModel.isEmbedded
                onClicked: {
                    App.instance.getNavigator().gotToScreen(Screens.configDetails)
                }

            }
            Flow {
                spacing: 20*UIUtils.UI.dp
                Label {
                    text: qsTr("Config edition")
                }
                Button {
                    text: qsTr("Editor")
                    onClicked: {
                        App.instance.getNavigator().gotToScreen(Screens.configMaker)
                    }

                }
            }

            Label {
                text:qsTr("Mentions: ")
            }
            Label {
                text:qsTr("Icons mentions")
            }
            Label {
                text:"https://github.com/Caerwent/Ma_chlas"
            }

        }
        Component.onCompleted: {
            checkBox.checked =GlobalConfigModel.isEmbedded
            configFileTxtField.text = GlobalConfigModel.externalFile
            languageCombo.currentIndex = languageCombo.indexOfValue(GlobalConfigModel.language)
        }

    }

}
