import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"
import "../scripts/loadJson.js" as JsonLoader
Item {
    id:activityChoice

    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        id: title
        text: qsTr("Activity choice")
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
                imgSource:ActivityCategories.getIconFromType(type)
                onSelected:
                {
                        activityFrame.loadActivities(configFile, type)

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
            console.log("Activities updateFromSession")
            var listData = Session.group.activities
            if(listData!==undefined)
            {
                            for (var i in listData) {
                                if(listData[i]["category"]===Session.activityCategory)
                                {
                                activityModel.append(
                                            {
                                                activityIndex: i,
                                                configFile:listData[i]["config"],
                                                type:listData[i]["type"],

                                            }
                                                      )
                                }
                            }
            }
        }

        Component.onCompleted: {
            console.log("Activities onCompleted")
            updateFromSession()
        }

        function loadActivities(configFile, activityType)
        {
            JsonLoader.loadJSON(GlobalConfigModel.config.path + configFile, resp=>{
                                    Session.activityPath = resp.path
                                    if(resp.path.startsWith("."))
                                    {
                                        Session.activityPath="file://"+GlobalConfigModel.config.path+resp.path.substring(2)
                                    }



                                    Session.selectedActivities = resp.activities ? resp.activities
                                                               .sort(function(a, b) {
                                                                   return a.level - b.level}) : []
                                    Session.activityType = activityType
                                    App.instance.getNavigator().gotToScreen(Screens.activityChoiceLevel)
                                }

         );
        }

    }
}
