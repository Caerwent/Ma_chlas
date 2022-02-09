import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Dialogs
import UIUtils 1.0 as UIUtils
import "../../main"
import "../../dataModels"
import "../../components"

ScreenTemplate {

    titleText: qsTr("MakerInitSession.title")
    Item {
        id:childrenFrame
        anchors.fill: parent
    ButtonGroup {
        id: radioGroup

    }

        Flow {
            id:choicesList
            anchors.margins: 20*UIUtils.UI.dp
            anchors.fill: parent
            spacing: 20*UIUtils.UI.dp
            flow: Flow.TopToBottom
            Label {
                text: qsTr("MakerInitSession.choices_label")
            }
            RadioButton {
                checked: true
                text: qsTr("MakerInitSession.choice_new_from_scratch")
                ButtonGroup.group: radioGroup
                onCheckedChanged:
                {
                    if(checked) MakerSession.mode = MakerSession.Mode.NewGlobal
                }
            }
            RadioButton {
                text: qsTr("MakerInitSession.choice_edit_global_config")
                ButtonGroup.group: radioGroup
                onCheckedChanged:
                {
                    if(checked) MakerSession.mode = MakerSession.Mode.EditGlobal
                }
            }
            RadioButton {
                text: qsTr("MakerInitSession.choice_new_activity")
                ButtonGroup.group: radioGroup
                onCheckedChanged:
                {
                    if(checked) MakerSession.mode = MakerSession.Mode.NewActivity
                }
            }
            RadioButton {
                text: qsTr("MakerInitSession.choice_edit_activity")
                ButtonGroup.group: radioGroup
                onCheckedChanged:
                {
                    if(checked) MakerSession.mode = MakerSession.Mode.EditActivity
                }
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
                    if(MakerSession.mode===MakerSession.Mode.NewGlobal)
                    {

                    }
                    else if(MakerSession.mode===MakerSession.Mode.EditGlobal)
                    {

                    }
                    else if(MakerSession.mode===MakerSession.Mode.NewActivity)
                    {

                    }
                    else if(MakerSession.mode===MakerSession.Mode.EditActivity)
                    {

                    }
                    else if(MakerSession.mode===MakerSession.Mode.NewCorpus)
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
