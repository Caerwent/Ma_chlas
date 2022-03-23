import QtQuick
import QtQuick.Controls
import QtMultimedia
import UIUtils 1.0 as UIUtils

import "../../main"
import "../../components"
import "../../dataModels"


ScreenTemplate {
    id:countPhonems

    titleText: qsTr("SlidingPuzzle.title")
    AppScrollView {
        id:screen
        anchors.fill: parent
        anchors.topMargin: 20*UIUtils.UI.dp

        SlidingPuzzleModel {
            id:itemModel

            onEnded: {
                App.instance.getNavigator().gotToScreen(Screens.score)
            }

            onStartStarAnimation: {
                startAnim.restart()
            }

        }

        Rectangle {
            id:screenContainer
            border.color:"transparent"
            color:"transparent"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle {
                id:scoreBar
                border.color :"transparent"
                anchors.top:parent.top
                anchors.left:parent.left
                color:Material.backgroundColor
                width: 100*UIUtils.UI.dp

                GaugeImage {
                    id:gauge
                    width: 80*UIUtils.UI.dp
                    height: 190*UIUtils.UI.dp
                    anchors.top: parent.top
                    anchors.topMargin: 40*UIUtils.UI.dp
                    anchors.horizontalCenter: parent.horizontalCenter
                    overlayEmptyColor: Material.backgroundDimColor
                    overlayFullColor: "#ED8A19"
                    fillPercent: itemModel.scorePercent
                    source: "qrc:///res/icons/starGauge.svg"
                }

            }


            Column {
                id:columnContainer
                property int imgContainerMaxSize: Math.min(screenContainer.width-scoreBar.width, 320*UIUtils.UI.dp)
                property int imgMaxSize: Math.min(screenContainer.width-scoreBar.width, 320*UIUtils.UI.dp)
                anchors.top: parent.top
                anchors.left: scoreBar.right
                anchors.right: parent.right


                ColoredImage {
                    id: check
                    width: 50*UIUtils.UI.dp
                    height: 50*UIUtils.UI.dp
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:///res/icons/eye.svg"
                    opacity: !itemModel.itemDone ? 1 : 0
                    overlayColor: refImg.visible ? Material.iconDisabledColor : Material.iconColor
                    onClicked:{
                        refImg.visible=!refImg.visible

                    }
                }

                Rectangle {
                    border.color:"transparent"
                    color:Material.backgroundColor
                    width: columnContainer.imgContainerMaxSize
                    height: columnContainer.imgContainerMaxSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    GridView {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        id: grid
                        property bool animRun:false
                        interactive: false
                        flow:GridView.FlowLeftToRight
                        width: columnContainer.imgMaxSize
                        height: columnContainer.imgMaxSize
                        cellWidth: (columnContainer.imgMaxSize/3)*UIUtils.UI.dp; cellHeight: (columnContainer.imgMaxSize/3)*UIUtils.UI.dp
                        model: itemModel.imgModel
                        delegate: Rectangle {
                            width: grid.cellWidth
                            height: grid.cellHeight
                            border.color:"transparent"
                            color:"transparent"
                            id:gridElt


                            ColoredImage {
                                id: puzzleAnchor
                                width: grid.cellWidth
                                height: grid.cellHeight
                                visible: (isBlank? isBlank : false) && !grid.animRun
                                source: "qrc:///res/icons/anchor.svg"
                                overlayColor: Material.primaryColor
                                hoverEnabled:false

                            }
                            Rectangle {
                                id:imgContent
                                border.color:"transparent"
                                color:"transparent"
                                width: grid.cellWidth
                                height: grid.cellHeight
                                visible: !isBlank
                                clip: true
                                NumberAnimation {
                                    id:yAnim
                                    target: imgContent
                                    properties: "y"
                                    duration: 400
                                    onStarted: {
                                        grid.animRun = true
                                    }

                                    onStopped: {
                                        itemModel.moveEnded()
                                        grid.animRun = false

                                    }
                                }
                                NumberAnimation {
                                    target: imgContent
                                    id:xAnim
                                    properties: "x"
                                    duration: 400
                                    onStarted: {
                                        grid.animRun = true
                                    }
                                    onStopped: {
                                        itemModel.moveEnded()
                                        grid.animRun = false

                                    }
                                }
                                Image {

                                    x: coord.col * (-grid.cellWidth)
                                    y: coord.row * (-grid.cellHeight)
                                    width: grid.width
                                    height: grid.height

                                    fillMode: Image.PreserveAspectFit
                                    source: itemModel.currentItem.image
                                    sourceSize: Qt.size(grid.width, grid.height)
                                }

                                Rectangle {
                                    width: grid.cellWidth
                                    height: grid.cellHeight
                                    border.color:Material.primary
                                    color:"transparent"
                                }

                                MouseArea {
                                    width: grid.cellWidth
                                    height: grid.cellHeight
                                    enabled: !(isBlank? isBlank : false) && (canMove ? canMove : false) && !grid.animRun
                                    onClicked : {
                                        var move = itemModel.move(row, col)
                                        if(move!==undefined)
                                        {
                                            if(move.col!==0)
                                            {
                                                xAnim.to = imgContent.x + grid.cellWidth*move.col
                                                xAnim.restart()
                                            } else  if(move.row!==0)
                                            {
                                                yAnim.to = imgContent.y + grid.cellHeight*move.row
                                                yAnim.restart()
                                            }

                                        }
                                    }
                                }
                            }
                        }




                    }
                    Rectangle {
                        border.color:"transparent"
                        color:Material.backgroundColor
                        width: columnContainer.imgMaxSize
                        height: columnContainer.imgMaxSize
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        id:refImg
                        visible: itemModel.itemDone
                        Image {
                            width: columnContainer.imgMaxSize
                            height: columnContainer.imgMaxSize
                            source: itemModel.currentItem?itemModel.currentItem.image:""
                            sourceSize: Qt.size(width, height)
                            fillMode: Image.PreserveAspectFit

                        }
                    }
                    ColoredImage {
                        id: next
                        width: 50*UIUtils.UI.dp
                        height: 50*UIUtils.UI.dp
                        anchors.topMargin: 10*UIUtils.UI.dp
                        anchors.top:refImg.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: "qrc:///res/icons/next.svg"
                        onClicked:{
                            itemModel.gotToNextItem()
                        }

                        Accessible.role: Accessible.Button
                        Accessible.name: qsTr("accessible.next")
                        Accessible.onPressAction: {
                            itemModel.gotToNextItem()
                        }
                    }
                    ColoredImage {
                        id: star
                        width: 50*UIUtils.UI.dp
                        height: 50*UIUtils.UI.dp
                        x:next.x+next.width+10*UIUtils.UI.dp
                        y:next.y
                        visible: itemModel.starVisibility
                        overlayColor: "#ED8A19"
                        hoverEnabled:false
                        source: "qrc:///res/icons/star.svg"
                        ParallelAnimation {
                            id: startAnim
                            NumberAnimation {
                                target: star
                                properties: "y"
                                to: gauge.y
                                duration: 400
                            }
                            NumberAnimation {
                                target: star
                                properties: "x"
                                to: gauge.x+gauge.width/2
                                duration: 400
                            }

                            onStopped: {
                                //star.visible=false
                                itemModel.starVisibility=false
                                star.x=next.x+next.width+10*UIUtils.UI.dp
                                star.y=next.y
                                itemModel.incrScore()
                                itemModel.gotToNextItemWhenStarAnimationEnded()
                            }
                        }


                    }
                }
                Component.onCompleted:
                {
                    itemModel.init(imgMaxSize)
                }
            }

        }

    }

}
