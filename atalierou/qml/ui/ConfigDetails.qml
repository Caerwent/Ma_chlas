import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"
import UserSession 1.0
import ActivityTreeElements 1.0
import TreeElements 1.0

ScreenTemplate {
    id:configDetails

    titleText: qsTr("My classroom")

    Item {
        id:groupFrame
        anchors.fill: parent

        ListModel {
            id: groupModel

        }
        ListModel {
            id: childrenModel

        }

        Flow {
            id: selector
            anchors.top:parent.top
            anchors.left:parent.left
            anchors.right: parent.right
            spacing: 10*UIUtils.UI.dp
            ComboBox {
                id: groupList
                model: groupModel


                width:150*UIUtils.UI.dp
                onModelChanged:
                {
                    currentIndex=0

                }
                onCurrentIndexChanged:  {
                    childrenModel.clear();
                    var listData = GlobalConfigModel.config.groups[currentIndex].children
                    for (var i in listData) {
                        childrenModel.append(
                                    {

                                        text: listData[i]["name"]

                                    }
                                    );
                    }
                }
            }
            ComboBox {
                id: childrenList
                model: childrenModel
                width:150*UIUtils.UI.dp
                onCurrentIndexChanged:{
                    scoresTree.treeModel = emptyModel
                    currentUser.group=GlobalConfigModel.config.groups[groupList.currentIndex].name
                    currentUser.name =  GlobalConfigModel.config.groups[groupList.currentIndex].children[currentIndex].name
                    currentUser.read(GlobalConfigModel.config.path)
                }
            }
            Button {
                text:qsTr("Export CSV")
                onClicked: {
                    fileDialog.visible=true
                }
            }


            FileDialog {
                id: fileDialog
                fileMode:FileDialog.SaveFile
                nameFilters: ["CSV file (*.csv)"]
                parentWindow: App.instance
                visible:false
                 onAccepted: {
                     currentUser.exportCSV(fileDialog.selectedFile) }
            }


        }




        Label {
            id: noScoreLabel
            anchors.top:selector.bottom
            anchors.right:parent.right
            anchors.left:parent.left
            text:qsTr("No score to display")
        }

        Rectangle {
            id: treePart
            anchors.top:selector.bottom
            anchors.bottom:parent.bottom
            anchors.right:parent.right
            anchors.left:parent.left

            border.color :"transparent"
            color:Material.backgroundColor
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

                    parentIndex: undefined
                    childCount: treeModel ? treeModel.rowCount() : 0
                    itemLeftPadding: 0
                }
            }
        }

        TreeModel {
            id:emptyModel
        }

        User {
            id:currentUser
            onError: { msg=>
                       App.showError(msg)
            }

            onScoresChanged : {
                if(currentUser.scores.rowCount()<=0)
                {
                    treePart.visible=false
                    noScoreLabel.visible=true
                    scoresTree.treeModel = emptyModel
                } else
                {
                    treePart.visible=true
                    noScoreLabel.visible=false
                    currentUser.scores.setRoles(["locked"])
                    scoresTree.treeModel = currentUser.scores
                }


            }
        }
        function updateGroupListFromConfig(inputConfig)
        {
            groupModel.clear();
            var listData = inputConfig.groups
            for (var i in listData) {
                groupModel.append(
                            {text: listData[i]["name"]}

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
