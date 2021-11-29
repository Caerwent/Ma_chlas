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
        id: groupFrame
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
            id: groupModel

        }

        Component {
            id: groupDelegate
            Card {
                width: groupGrid.cellWidth;
                height: groupGrid.cellHeight
                selectable:true
                padding:10
                label:name
                imgSource:image

                onSelected:
                {
                    Session.group = GlobalConfigModel.config.groups[groupIndex]
                    if(hasChildren)
                        App.instance.getNavigator().gotToScreen(Screens.children)
                    else
                        App.instance.getNavigator().gotToScreen(Screens.activitiesGroupChoice)
                }



            }


        }

        GridView {
            id: groupGrid
            anchors.fill: parent
            cellWidth: 150*UIUtils.UI.dp; cellHeight: 150*UIUtils.UI.dp
flow:GridView.FlowLeftToRight
            model: groupModel
            delegate: groupDelegate
            focus: true
        }

        function updateFromConfig(inputConfig)
        {
            groupModel.clear();
            console.log("Home updateFromConfig")
            var listData = inputConfig.groups
                            for (var i in listData) {
                                groupModel.append(
                                            {
                                                groupIndex: i,
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
                groupFrame.updateFromConfig(GlobalConfigModel.config)
            }
        }

        Component.onCompleted: {
            console.log("Home onCompleted")
            GlobalConfigModel.config ? updateFromConfig(GlobalConfigModel.config) : console.log("Home onCompleted, GlobalConfigModel not ready")
        }
    }




}
