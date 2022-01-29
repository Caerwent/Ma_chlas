import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "../main"
import "../dataModels"
import "../components"

ScreenTemplate {
    id:activities

    titleText: qsTr("Activities group choice")


    Item {
        anchors.fill: parent
        ListModel {
            id: activityModel


        }

        Component {
            id: activityDelegate
            Card {
                id:activity
                width: activityGrid.cellWidth;
                height: activityGrid.cellHeight
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

        GridView {
            id: activityGrid
            anchors.fill: parent
            cellWidth: 150*UIUtils.UI.dp; cellHeight: 150*UIUtils.UI.dp
            flow:GridView.FlowLeftToRight
            model: activityModel
            delegate: activityDelegate
            focus: true
        }

        function updateFromSession(inputConfig)
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
