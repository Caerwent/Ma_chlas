import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "../main"
import "../components"
import "../dataModels"

ScreenTemplate {
    id:activityChoiceLevel

    titleText: qsTr("Activity Level")

    AppScrollView {
        id:screen
        anchors.fill: parent
        anchors.topMargin: 20*UIUtils.UI.dp
        Column {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            spacing: 10*UIUtils.UI.dp
            Repeater {
                id: levelRepeater
                model: Session.selectedActivities? Session.selectedActivities.length:0

                Flow {
                    id:levelRow
                    spacing: 5*UIUtils.UI.dp
                    property int levelRepeaterIndex :index
                    property int levelScore
                    property bool isLocked
                    anchors.left: parent.left
                    anchors.right: parent.right
                    flow:Flow.LeftToRight

                    GaugeImage {
                        width: 60*UIUtils.UI.dp
                        height: 120*UIUtils.UI.dp
                        anchors.verticalCenter: parent.verticalCenter
                        visible:Session.user!==undefined && Session.user.scoreTypeNode!==undefined
                        id:scoreView
                        isAnimated:false
                        overlayEmptyColor: Material.backgroundDimColor
                        overlayFullColor: "#ED8A19"
                        fillPercent:  levelScore
                        source: "qrc:///res/icons/starGauge.svg"
                        Accessible.role: Accessible.StaticText
                        Accessible.name: qsTr("accessible.score_%1").arg(levelScore)

                    }
                    Repeater {
                        id: exoRepeater
                        model: Session.selectedActivities ? Session.selectedActivities[levelRepeaterIndex].exercices.length : 0

                        Card {
                            id:itemLevel
                            width: 140*UIUtils.UI.dp;
                            height: 140*UIUtils.UI.dp
                            selectable:true
                            padding:10
                            label:Session.selectedActivities[levelRepeaterIndex].exercices[index].name
                            imgSource:ActivityCategories.getIconFromType(Session.activityType)
                            bkgColor : ActivityCategories.getColorStringFromLevel(Session.selectedActivities[levelRepeaterIndex].level)
                            enabled: !isLocked
                            onSelected:
                            {
                                Session.activityIndex = levelRepeaterIndex
                                Session.exerciceIndex=index
                                App.instance.getNavigator().gotToScreen(ActivityCategories.getScreenFromType(Session.activityType))

                            }
                            Component.onCompleted: {
                                console.log("levelRepeaterIndex="+levelRepeaterIndex," index="+index," (level="+Session.selectedActivities[levelRepeaterIndex].level+")")
                            }
                            Image {
                                id: lockedIcon
                                visible: isLocked
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.margins: 10*UIUtils.UI.dp
                                source: "qrc:///res/icons/locked.svg"
                                width: 40*UIUtils.UI.dp
                                height: 40*UIUtils.UI.dp
                            }

                          Accessible.role: Accessible.Button
                          Accessible.name: isLocked ? qsTr("accessible.level %1 exo %2 locked").arg(Session.selectedActivities[levelRepeaterIndex].level).arg(itemLevel.label) : qsTr("accessible.level %1 exo %2 unlocked")
                          Accessible.onPressAction: {
                                    itemLevel.selected()
                                }

                            }
                    }
                    Component.onCompleted: {
                        isLocked = levelRepeater.isLevelLocked(levelRepeaterIndex+1)
                        levelScore = levelRepeater.getMeanScore(levelRepeaterIndex+1)
                    }
                }
                Component.onCompleted:  {

                    if(Session.user!==undefined)
                    {
                        Session.user.onScoreTypeNodeChanged.connect(userScoresChanged)

                    }



                }

                function userScoresChanged(scores)
                {
                    levelRepeater.model = 0
                    levelRepeater.model = Session.selectedActivities? Session.selectedActivities.length:0
                }

                function getMeanScore(levelIndex)
                {
                    if(Session.user===undefined)
                        return 0
                    var nodes = Session.user.scoreTypeNode.getTreeNodes()

                    for( var curNode in nodes)
                    {
                        if(nodes[curNode].level===levelIndex) {

                            return nodes[curNode].meanScore

                        }
                    }
                    return 0
                }

                function isLevelLocked(levelIndex)
                {

                    if(Session.user===undefined)
                        return false
                    else if (levelIndex<=1)
                    {
                        return false
                    }
                    else if(Session.user.scoreTypeNode!==undefined )
                    {
                        var nodes = Session.user.scoreTypeNode.getTreeNodes()
                        var lowerLevelHasScore = false
                        var currentLevelLock=false
                        for( var curNode in nodes)
                        {
                            if(nodes[curNode].level===levelIndex) {
                                currentLevelLock= nodes[curNode].locked

                            }
                            else if(nodes[curNode].level<levelIndex)
                            {
                                var levelScores = nodes[curNode].getTreeNodes()
                                lowerLevelHasScore = levelScores!==undefined && levelScores.length >0
                                if(nodes[curNode].locked)
                                    return true
                                else if (nodes[curNode].level===levelIndex-1 && nodes[curNode].meanScore <Session.user.levelUnlockedWithScore)
                                    return true
                            }
                        }
                        if(currentLevelLock)
                            return true
                        else if(!lowerLevelHasScore)
                            return true
                        else
                            return false
                    }

                    return true
                }
            }


        }
    }

}
