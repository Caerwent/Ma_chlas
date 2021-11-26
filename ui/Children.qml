import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"

Item {
    id:childrenComponent
    property var classRoomIndex

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
        Item {
            width: childrenGrid.cellWidth
            height: childrenGrid.cellHeight
            Rectangle {
                width: (childrenGrid.cellWidth-10*UIUtils.UI.dp)
                height: (childrenGrid.cellWidth-10*UIUtils.UI.dp)
                anchors.horizontalCenter: parent.horizontalCenter
                 anchors.verticalCenter: parent.verticalCenter
                border.color:Material.primary
                border.width: 2*UIUtils.UI.dp
                radius: 10*UIUtils.UI.dp
                MouseArea {
                       anchors.fill: parent
                       hoverEnabled: true
                       onEntered:{
                           parent.border.color = Material.accent
                       }

                       onExited :{
                           parent.border.color = Material.primary
                       }
                       onClicked: {
                           App.instance.getNavigator().gotToScreen(Screens.games)
                       }
                   }
            Column {
                width: (parent.width-10*UIUtils.UI.dp)
                height: (parent.height-10*UIUtils.UI.dp)
                anchors.horizontalCenter: parent.horizontalCenter
                 anchors.verticalCenter: parent.verticalCenter
                spacing: 2*UIUtils.UI.dp
                Label {
                    text: name;
                    color:Material.primary
                    width: (parent.width-20*UIUtils.UI.dp)
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 16
                    horizontalAlignment: Text.AlignHCenter

                       wrapMode: Text.Wrap
                }
                Image { source: image;

                    width: (parent.width-20*UIUtils.UI.dp)
                 //   height: (childrenGrid.cellWidth-20*UIUtils.UI.dp)
                    anchors.horizontalCenter: parent.horizontalCenter

                    sourceSize: Qt.size(width, height)
                }



               }
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
                    var childrenList = GlobalConfigModel.config.classes[classRoomIndex].children
                        for (var i in childrenList) {
                            childrenModel.append(
                                        {
                                            name: childrenList[i]["name"],
                                             image: GlobalConfigModel.config.path+childrenList[i]["image"],
                                        }
                                                  );
                        }
    }
}


    onClassRoomIndexChanged : {
        childrenFrame.updateFromConfig()
    }


    Component.onCompleted: {
        childrenFrame.updateFromConfig()
    }

}

