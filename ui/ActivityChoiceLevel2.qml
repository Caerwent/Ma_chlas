import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"

Item {
    id:activityChoiceLevel

    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        id: title
        text: qsTr("Activity Level")
        anchors.topMargin: 20*UIUtils.UI.dp
        anchors.leftMargin: 20*UIUtils.UI.dp
        anchors.rightMargin: 20*UIUtils.UI.dp
        font.pointSize: 20
    }

    Rectangle {

        id:activityFrame
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

        Column {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10*UIUtils.UI.dp
            Repeater {
                        id: levelRepeater
                        model: Session.selectedActivities? Session.selectedActivities.length:0

                            Row {
                                spacing: 5*UIUtils.UI.dp
                            property int levelRepeaterIndex :index
                            anchors.left: parent.left
                            anchors.right: parent.right
                                Repeater {
                                    id: exoRepeater
                                    model: Session.selectedActivities[levelRepeaterIndex].exercices.length

                                    Card {
                                        width: 150*UIUtils.UI.dp;
                                        height: 150*UIUtils.UI.dp
                                        selectable:true
                                        padding:10
                                        label:Session.selectedActivities[levelRepeaterIndex].exercices[index]
                                        imgSource:ActivityCategories.getIconFromType(Session.activityType)
                                        bkgColor : ActivityCategories.getColorStringFromLevel(Session.selectedActivities[levelRepeaterIndex].level)
                                        onSelected:
                                        {
                                            Session.activityIndex = levelRepeaterIndex
                                            Session.exerciceIndex=index
                                            App.instance.getNavigator().gotToScreen(ActivityCategories.getScreenFromType(Session.activityType))

                                        }
                                        Component.onCompleted: {
                                            console.log("levelRepeaterIndex="+levelRepeaterIndex," index="+index," (level="+Session.selectedActivities[levelRepeaterIndex].level+")")
                                        }



                                    }
                                }
                            }


            }
        }



    }
}
