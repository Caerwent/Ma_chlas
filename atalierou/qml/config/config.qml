import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Dialogs
import UIUtils 1.0 as UIUtils
import "../main"
import "../dataModels"

Component {
    id:configurationComponent
    Frame {

        id:configurationScreen

        property var fileOpenDialog: FileDialog {

            modality: Qt.WindowModal
            title: qsTr("Choose a configuration file")
            nameFilters: [ qsTr("Json files (*.json)")]

            onAccepted: {
                console.log("selected: " + selectedFile)
                configFileTxtField.text=selectedFile
            }
        }
        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            id: title
            text: qsTr("Configuration")
            anchors.topMargin: 20*UIUtils.UI.dp
            anchors.leftMargin: 20*UIUtils.UI.dp
            anchors.rightMargin: 20*UIUtils.UI.dp
            font.pointSize: 20
        }
        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: title.bottom
            anchors.topMargin: 20*UIUtils.UI.dp
            anchors.leftMargin: 20*UIUtils.UI.dp
            anchors.rightMargin: 20*UIUtils.UI.dp
            spacing: 20*UIUtils.UI.dp
            CheckBox {
                id: checkBox
                text: qsTr("Use embedded configuration")

                onCheckedChanged: {
                    externalConfig.enabled=!checked
                }
            }
            Flow {
                id:externalConfig
                spacing: 20*UIUtils.UI.dp
                Label {
                    text: qsTr("Use external configuration")
                    anchors.leftMargin: 20*UIUtils.UI.dp
                }
                TextField {
                    anchors.leftMargin: 20*UIUtils.UI.dp
                    id: configFileTxtField

                    placeholderText: qsTr("Enter a JSON configuration file")
                }
                Button {
                    anchors.leftMargin: 20*UIUtils.UI.dp
                    text: qsTr("Open file...")
                    onClicked: {
                        fileOpenDialog.open()
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
