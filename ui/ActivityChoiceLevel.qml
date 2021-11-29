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

        ListModel {
            id: activityModel


        }

        Component {
            id: activityDelegate
            Card {
                width: activityGrid.cellWidth;
                height: activityGrid.cellHeight
                selectable:true
                padding:10
                imgSource:ActivityCategories.getIconFromType(Session.activityType)
                bkgColor : ActivityCategories.getColorStringFromLevel(activityLevel)
                onSelected:
                {
                    Session.activityLevel = activityLevel
                    App.instance.getNavigator().gotToScreen(ActivityCategories.getScreenFromType(Session.activityType))

                }



            }


        }

        GridView {
            id: activityGrid
            anchors.fill: parent
            cellWidth: 150*UIUtils.UI.dp; cellHeight: 150*UIUtils.UI.dp
flow:GridView.FlowLeftToRight
            model: activityModel
            delegate: activityDelegate
            focus: true
        }



        function updateFromSession()
        {
            activityModel.clear();


            if(Session.selectedActivities!==undefined)
            {
                for (var i in Session.selectedActivities) {

                        activityModel.append(
                                    {
                                        activityIndex: i,
                                        activityLevel:Session.selectedActivities[i].level

                                    }
                                    );

                }
            }
        }

        Component.onCompleted: {

            updateFromSession()
        }

    }
}
