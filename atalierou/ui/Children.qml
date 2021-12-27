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
        text: qsTr("Children")
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

        ListModel {
            id: childrenModel

        }



    Component {
        id: childrenDelegate
        Avatar {
            width: childrenGrid.cellWidth
            height: childrenGrid.cellHeight
            child:childRef
            isSelectable:true
            onSelected: {
                Session.loadUser(indexChild)
                App.instance.getNavigator().gotToScreen(Screens.activitiesGroupChoice)
            }
        }
    }

    GridView {
        id: childrenGrid
        anchors.fill:parent
        cellWidth: 100*UIUtils.UI.dp; cellHeight: 100*UIUtils.UI.dp
flow:GridView.FlowLeftToRight
        model: childrenModel
        delegate: childrenDelegate
        focus: true
    }

    function updateFromConfig()
    {
        childrenModel.clear();
        console.log("children updateFromConfig")
                    var childrenList = Session.group.children
                        for (var i in childrenList) {
                            childrenModel.append(
                                        {
                                            indexChild:i,
                                            childRef: childrenList[i]
                                        }
                                                  );
                        }
    }
}




    Component.onCompleted: {
        childrenFrame.updateFromConfig()
    }


}

