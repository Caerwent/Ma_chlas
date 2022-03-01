import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Dialogs
import UIUtils 1.0 as UIUtils
import "../../main"
import "../../dataModels"
import "../../components"

ScreenTemplate {

     titleText: qsTr("MakerInitSession.title")

    AppScrollView {
        id:screen
        anchors.fill: parent
        anchors.topMargin: 20*UIUtils.UI.dp



        Flow {
            id:choicesList
            anchors.margins: 20*UIUtils.UI.dp
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 20*UIUtils.UI.dp
            flow: Flow.TopToBottom
            ButtonGroup {
                id: radioGroup

            }
            Label {
                text: qsTr("MakerInitSession.choices_label")
            }

            RadioButton {
                text: qsTr("MakerInitSession.choice_new_corpus")
                ButtonGroup.group: radioGroup
                onCheckedChanged:
                {
                    if(checked) MakerSession.mode = MakerSession.Mode.NewCorpus
                }
            }
            RadioButton {
                text: qsTr("MakerInitSession.choice_edit_corpus")
                ButtonGroup.group: radioGroup
                onCheckedChanged:
                {
                    if(checked) MakerSession.mode = MakerSession.Mode.EditCorpus
                }
            }
            Button {
                enabled: radioGroup.checkState!=Qt.Unchecked
                text: qsTr("MakerInitSession.valid_btn")
                onClicked: {
                   if(MakerSession.mode===MakerSession.Mode.NewCorpus)
                    {
                        App.instance.getNavigator().gotToScreen(Screens.configMakerCorpus)
                    }
                    else if(MakerSession.mode===MakerSession.Mode.EditCorpus)
                    {
                        App.instance.getNavigator().gotToScreen(Screens.configMakerCorpus)
                    }

                }

            }
        }
    }
}
