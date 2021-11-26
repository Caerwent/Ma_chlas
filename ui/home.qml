import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"
Item {
    id:home

    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        id: title
        text: qsTr("My classroom")
        anchors.topMargin: 20*UIUtils.UI.dp
        anchors.leftMargin: 20*UIUtils.UI.dp
        anchors.rightMargin: 20*UIUtils.UI.dp
        font.pointSize: 20
    }

    ColoredImage {
        id: configImg
        source: "qrc:///res/icons/gear.svg"
        anchors.top: title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 40*UIUtils.UI.dp
        height: 40*UIUtils.UI.dp
        anchors.topMargin: 20*UIUtils.UI.dp
        MouseArea {
            anchors.fill: parent
            onClicked: {
                App.instance.getNavigator().gotToScreen(Screens.config)
            }
        }
    }

    Rectangle {
        id: classroomFrame
        anchors.top: configImg.bottom
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
            id: classroomModel

        }

        Component {
            id: classroomDelegate
            Card {
                width: classroomGrid.cellWidth;
                height: classroomGrid.cellHeight
                selectable:true
                padding:10
                label:name
                imgSource:image

                onSelected:
                {
                    Session.classRoom = GlobalConfigModel.config.classes[classRoomIndex]
                    if(hasChildren)
                        App.instance.getNavigator().gotToScreen(Screens.children)
                    else
                        App.instance.getNavigator().gotToScreen(Screens.games)
                }



            }


        }

        GridView {
            id: classroomGrid
            anchors.fill: parent
            cellWidth: 150*UIUtils.UI.dp; cellHeight: 150*UIUtils.UI.dp
flow:GridView.FlowLeftToRight
            model: classroomModel
            delegate: classroomDelegate
            focus: true
        }

        function updateFromConfig(inputConfig)
        {
            classroomModel.clear();
            console.log("Home updateFromConfig")
            var listData = inputConfig.classes
                            for (var i in listData) {
                                classroomModel.append(
                                            {
                                                classRoomIndex: i,
                                                name: listData[i]["name"],
                                                 image: inputConfig.path+listData[i]["image"],
                                                hasChildren:listData[i]["children"]?listData[i]["children"].length>0 : false

                                            }
                                                      );
                            }
        }


        Connections {
            target: GlobalConfigModel

            function onConfigChanged(inputConfig) {
                console.log("GlobalConfigModel onValueChanged")
                classroomFrame.updateFromConfig(GlobalConfigModel.config)
            }
        }

        Component.onCompleted: {
            console.log("Home onCompleted")
            GlobalConfigModel.config ? updateFromConfig(GlobalConfigModel.config) : console.log("Home onCompleted, GlobalConfigModel not ready")
        }
    }




}
