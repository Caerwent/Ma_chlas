import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"
import "../components"
import UserSession 1.0
import GlobalConfigData 1.0

Item {
    id: home

    ColoredImage {
        id: configImg
        source: "qrc:///res/icons/gear.svg"
        anchors.top: parent.top
        anchors.right: parent.right
        width: 40 * UIUtils.UI.dp
        height: 40 * UIUtils.UI.dp
        anchors.topMargin: 20 * UIUtils.UI.dp
        anchors.rightMargin: 20 * UIUtils.UI.dp
        MouseArea {
            anchors.fill: parent
            onClicked: {
                App.instance.getNavigator().gotToScreen(Screens.config)
            }
        }

        Accessible.role: Accessible.Button
        Accessible.name: qsTr("accessible.config")
        Accessible.onPressAction: {
            App.instance.getNavigator().gotToScreen(Screens.config)
        }

    }
    Label {
        anchors.left: parent.left
        anchors.right: configImg.left
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        id: title
        text: qsTr("home_title")
        anchors.topMargin: 20 * UIUtils.UI.dp
        anchors.leftMargin: 20 * UIUtils.UI.dp
        anchors.rightMargin: 20 * UIUtils.UI.dp
        font.pointSize: 40
    }
    Label {
        anchors.left: parent.left
        anchors.right: configImg.left
        anchors.top: title.bottom
        horizontalAlignment: Text.AlignHCenter
        id: version
        text: GlobalConfigData.version
        anchors.topMargin: 10 * UIUtils.UI.dp
        anchors.leftMargin: 20 * UIUtils.UI.dp
        anchors.rightMargin: 20 * UIUtils.UI.dp
        font.pointSize: 20
    }

    Rectangle {
        id: groupFrame
        anchors.top: version.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 40 * UIUtils.UI.dp
        anchors.topMargin: 40 * UIUtils.UI.dp
        anchors.rightMargin: 40 * UIUtils.UI.dp
        anchors.bottomMargin: 40 * UIUtils.UI.dp
        border.color: "transparent"
        color: Material.backgroundColor
        ListModel {
            id: groupModel
        }

        Component {
            id: groupDelegate
            Card {
                id:group
                width: groupGrid.cellWidth-10*UIUtils.UI.dp
                height: groupGrid.cellHeight-10*UIUtils.UI.dp
                selectable: true
                padding: 10
                label: name
                imgSource: image

                onSelected: {
                    Session.group = GlobalConfigModel.config.groups[groupIndex]
                    if (hasChildren)
                        App.instance.getNavigator().gotToScreen(
                                    Screens.children)
                    else {
                        App.instance.getNavigator().gotToScreen(
                                    Screens.activitiesGroupChoice)
                        Session.loadUser()
                    }
                }



                    Accessible.role: Accessible.Button
                    Accessible.name: name
                    Accessible.onPressAction: {
                        group.selected()
                    }


            }
        }

        GridView {
            id: groupGrid
            anchors.fill: parent
            cellWidth: 150 * UIUtils.UI.dp
            cellHeight: 150 * UIUtils.UI.dp
            flow: GridView.FlowLeftToRight
            model: groupModel
            delegate: groupDelegate
            focus: true
        }

        function updateFromConfig(inputConfig) {
            groupModel.clear()
            console.log("Home updateFromConfig")
            var listData = inputConfig.groups
            for (var i in listData) {
                groupModel.append({
                                      "groupIndex": i,
                                      "name": listData[i]["name"],
                                      "image": inputConfig.path + listData[i]["image"],
                                      "hasChildren": listData[i]["children"] ? listData[i]["children"].length > 0 : false
                                  })
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
            GlobalConfigModel.config ? updateFromConfig(
                                           GlobalConfigModel.config) : console.log(
                                           "Home onCompleted, GlobalConfigModel not ready")
        }
    }
}
