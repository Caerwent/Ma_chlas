import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
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
                currentUser.scores.setRoles(["locked"])
                //groupFrame.logDebugViewmodel(0,0)
                scoresTree.treeModel = currentUser.scores
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

        function logDebugViewmodel(row, depth, parentIndex)
        {

            var nodeIndex = parentIndex ? currentUser.scores.index(row,0, parentIndex) : currentUser.scores.index(row,0)
            var rowCount=currentUser.scores.rowCount(nodeIndex)
            /*  var columnCount = currentUser.scores.columnCount(nodeIndex)
            console.log("depth=",depth, " row=",row," nodeIndex=", nodeIndex, " row count =",rowCount, " columnCount=", columnCount)

            for(var col=0;col<columnCount;col++)
            {
                var prop = currentUser.scores.data(nodeIndex, col)
                if(prop!==undefined)
                    console.log("data ",prop["name"],"=",prop["value"])
                else
                    console("no data")
            }*/
            console.log("depth=",depth, " row=",row," nodeIndex=", nodeIndex, " data=",currentUser.scores.data(nodeIndex, Qt.DisplayRole))

            for(var i=0; i<rowCount; i++)
            {
                logDebugViewmodel(i, depth+1, nodeIndex)
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
