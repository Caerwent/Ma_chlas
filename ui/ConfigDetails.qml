import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"
import UserSession 1.0
import ActivityTreeElements 1.0
import TreeElements 1.0
Item {
    id:configDetails


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

    Rectangle {


        id: groupFrame
        anchors.top: parent.top
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
        ListModel {
            id: childrenModel

        }

        Component {
            id: groupDelegate
            Text {

                text:name
                MouseArea {
                    id:mouseArea

                       anchors.fill: parent
                       hoverEnabled: true
                       onEntered:{
                           parent.color = Material.accent
                       }

                       onExited :{
                           parent.color = Material.foreground
                       }

                       onClicked: {
                           groupList.currentIndex = index

                           childrenModel.clear();
                           var listData = GlobalConfigModel.config.groups[groupIndex].children
                                           for (var i in listData) {
                                               childrenModel.append(
                                                           {

                                                               name: listData[i]["name"]

                                                           }
                                                                     );
                                           }
                       }

                   }
            }
        }

        Component {
            id: childDelegate
            Text {
                text:name

                MouseArea {
                    id:mouseArea

                       anchors.fill: parent
                       hoverEnabled: true
                       onEntered:{
                           parent.color = Material.accent
                       }

                       onExited :{
                           parent.color = Material.foreground
                       }

                       onClicked: {
                           childrenList.currentIndex = index
                           currentUser.group=GlobalConfigModel.config.groups[groupList.currentIndex].name
                           currentUser.name =  name
                           currentUser.read(GlobalConfigModel.config.path)


                       }
                   }




            }


        }

        ListView {
            id: groupList
            anchors.top:parent.top
            height:parent.height/2
            anchors.left:parent.left
            width:parent.width/2
            model: groupModel
            delegate: groupDelegate
            focus: true
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }



        }
        ListView {
            id: childrenList
            anchors.top:groupList.bottom
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            width:parent.width/2
            model: childrenModel
            delegate: childDelegate
            focus: true
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }

        }

        Rectangle {
                   id: treePart
                   anchors.top:parent.top
                   anchors.bottom:parent.bottom
                   anchors.right:parent.right
                   anchors.left:groupList.right

                   border {
                       width: 1
                       color: "gray"
                   }
                   clip: true

                   Flickable {
                       id: toolbarFlickable

                       anchors.fill: parent
                       contentHeight: scoresTree.height
                       contentWidth: parent.width
                       boundsBehavior: Flickable.StopAtBounds
                       ScrollBar.vertical: ScrollBar {}

                       TreeItem {
                           id: scoresTree

                           anchors {
                               top: parent.top
                               left: parent.left
                               leftMargin: 5
                               topMargin: 5
                           }

                           parentIndex: treeModel ? treeModel.index(0,0) : 0
                           childCount: treeModel ? treeModel.rowCount(parentIndex) : 0
                           itemLeftPadding: 0
                       }
                   }
               }


        User {
            id:currentUser
                onError: { msg=>
                    App.showError(msg)
                }

                onScoresChanged : {
                    scoresTree.treeModel = currentUser.scores
                }
            }
        function updateGroupListFromConfig(inputConfig)
        {
            groupModel.clear();
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
                groupFrame.updateGroupListFromConfig(GlobalConfigModel.config)
            }
        }

        Component.onCompleted: {
            console.log("Home onCompleted")
            GlobalConfigModel.config ? updateGroupListFromConfig(GlobalConfigModel.config) : console.log("Home onCompleted, GlobalConfigModel not ready")
        }


    }




}
