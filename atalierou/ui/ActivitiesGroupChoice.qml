import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"
Item {
    id:activities

    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        id: title
        text: qsTr("Activities group choice")
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
                imgSource:ActivityCategories.getIconFromCategory(category)
                onSelected: {
                    Session.activityCategory = category
                    App.instance.getNavigator().gotToScreen(Screens.activityChoice)
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
