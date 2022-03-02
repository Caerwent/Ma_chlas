import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "../main"
import "../components"
import "../dataModels"

ScreenTemplate {
    id:activities

    titleText: qsTr("Activity choice")

    AppScrollView {
        id:screen
        anchors.fill: parent
        anchors.topMargin: 20*UIUtils.UI.dp

        Flow {
            id: activityGrid
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            flow:Flow.LeftToRight
            spacing: 10*UIUtils.UI.dp

            Repeater {
                model: ListModel {
                    id: activityModel


                }

                delegate: Component {
                    id: activityDelegate
                    Card {
                        id:activity
                        width: 150*UIUtils.UI.dp-10*UIUtils.UI.dp
                        height: 150*UIUtils.UI.dp-10*UIUtils.UI.dp
                        selectable:true
                        padding:10
                        imgSource:ActivityCategories.getIconFromType(type)
                        onSelected:
                        {
                            GlobalConfigModel.loadActivities(configFile,
                                                             Session.activityCategory,
                                                             type,
                                                             cbResp =>{
                                                                 App.instance.getNavigator().gotToScreen(Screens.activityChoiceLevel)
                                                             })

                        }



                        Accessible.role: Accessible.Button
                        Accessible.name: ActivityCategories.getAccessibleFromType(Session.activityCategory)
                        Accessible.onPressAction: {
                            activity.selected()
                        }


                    }


                }
            }
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

    }



}
