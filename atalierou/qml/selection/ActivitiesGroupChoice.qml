import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "../main"
import "../dataModels"
import "../components"

ScreenTemplate {
    id:activities

    titleText: qsTr("Activities group choice")


    AppScrollView {
        id:screen
        anchors.fill: parent
        anchors.topMargin: 20*UIUtils.UI.dp





        GridView {
            id: activityGrid
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            cellWidth: 150*UIUtils.UI.dp; cellHeight: 150*UIUtils.UI.dp
            flow:GridView.FlowLeftToRight
            model: ListModel {
                id: activityModel


            }
            delegate: Component {
                id: activityDelegate

                Card {
                    id:activity
                    width: activityGrid.cellWidth-10*UIUtils.UI.dp;
                    height: activityGrid.cellHeight-10*UIUtils.UI.dp
                    selectable:true
                    padding:10
                    imgSource:ActivityCategories.getIconFromCategory(category)
                    onSelected: {
                        Session.activityCategory = category
                        App.instance.getNavigator().gotToScreen(Screens.activityChoice)
                    }


                    Accessible.role: Accessible.Button
                    Accessible.name: ActivityCategories.getAccessibleFromCategory(ActivityCategories)
                    Accessible.onPressAction: {
                            activity.selected()
                        }


                }


            }
            interactive: false
            focus: true
        }

        function updateFromSession()
        {
            activityModel.clear();

            var listData = Session.group.activities

            var categoriesList = []
            if(listData!==undefined)
            {
                for (var i in listData) {
                    if(!categoriesList.find(element =>
                                      element===listData[i]["category"]))
                    {

                        categoriesList.push(listData[i]["category"])
                        activityModel.append(
                                    {
                                        activityIndex: i,
                                        category:listData[i]["category"],
                                    }
                                    );
                    }
                }
            }
        }

        Component.onCompleted: {

            updateFromSession()
        }
    }

}
