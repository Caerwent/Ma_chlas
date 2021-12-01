import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"

Item {
    id:childrenComponent

    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        id: title
        text: qsTr("Score")
        anchors.topMargin: 20*UIUtils.UI.dp
        anchors.leftMargin: 20*UIUtils.UI.dp
        anchors.rightMargin: 20*UIUtils.UI.dp
        font.pointSize: 20
    }
    Rectangle {

        id:childrenFrame
        anchors.top: title.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 40*UIUtils.UI.dp
        anchors.topMargin: 40*UIUtils.UI.dp
        anchors.rightMargin: 40*UIUtils.UI.dp
        anchors.bottomMargin: 40*UIUtils.UI.dp
        border.color :"transparent"
        color:Material.backgroundColor


        Flow {
            id:scorePanel
           anchors.verticalCenter: parent.verticalCenter

            anchors.horizontalCenter: parent.horizontalCenter
            flow:Flow.LeftToRight
            spacing: 10*UIUtils.UI.dp

            add: Transition {
                id: trans
                ParallelAnimation {
                    PropertyAnimation { properties: "x"; from:0; to:trans.ViewTransition.destination.x; duration: 2000; easing.type: Easing.Linear }
                    PropertyAnimation { properties: "y"; from:0; to:trans.ViewTransition.destination.y; duration: 2000; easing.type: Easing.Linear }
                    NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 2000 }
                    NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 2000 }
                }
            }

            Repeater {
                        id: scoreRepeater
                        model: Session.selectedActivities[Session.activityLevel].items.length
                        delegate:

                            ColoredImage {

                                        id: delegateStar
                                        width: 50*UIUtils.UI.dp
                                        height: 50*UIUtils.UI.dp
                                        source: "qrc:///res/icons/star.svg"
                                        overlayColor: index < Session.activityScore ? "#ED8A19" : "#999999"
                                         hoverEnabled:false



                        }
            }
        }



    }


}

