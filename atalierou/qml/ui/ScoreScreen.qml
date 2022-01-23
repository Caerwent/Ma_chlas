import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"
import QtQuick.Particles
Item {
    id:childrenComponent

    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        id: title
        text: qsTr("Score")
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

        Component.onCompleted: {
            scorePanel.fillPercent=Session.exerciceScore
        }

        Rectangle {
            border.color :"transparent"
            color:Material.backgroundColor

            width: 160*UIUtils.UI.dp
            anchors.top:parent.top
            anchors.bottom:parent.bottom
             anchors.horizontalCenter: parent.horizontalCenter

             //https://qmlbook.github.io/ch10-particles/particles.html
             Rectangle {
                 id:particules
                 width: 50*UIUtils.UI.dp
                 height: 150*UIUtils.UI.dp
                 border.color :"transparent"
                 color:Material.backgroundColor
                 anchors.horizontalCenter: parent.horizontalCenter
        ParticleSystem {
                id: particleSystem

            }

            Emitter {
                id: emitter
                anchors.fill: parent
                system: particleSystem
                emitRate: Session.exerciceScore? 10 * Session.exerciceScore/100 : 0
                lifeSpan: 1000
                lifeSpanVariation: 500
                size: 10*UIUtils.UI.dp
                endSize: 32*UIUtils.UI.dp
                velocity: AngleDirection {
                            angle: 270
                            angleVariation: 15
                            magnitude: 50
                            magnitudeVariation: 25
                        }
            }

            ImageParticle {
                source: "qrc:///res/icons/star.svg"
                system: particleSystem
                color: '#ED8A19'
            }
             }
        GaugeImage {
            width: 160*UIUtils.UI.dp
            height: 320*UIUtils.UI.dp
            anchors.top:particules.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            id:scorePanel
            isAnimated:false
            overlayEmptyColor: Material.backgroundDimColor
            overlayFullColor: "#ED8A19"
            fillPercent: 0
            source: "qrc:///res/icons/starGauge.svg"



        }

        ColoredImage {
            id: check
            width: 50*UIUtils.UI.dp
            height: 50*UIUtils.UI.dp
            anchors.topMargin: 30*UIUtils.UI.dp
            anchors.top: scorePanel.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:///res/icons/next.svg"
            onClicked:{

                App.instance.getNavigator().back()
            }
        }
        }









    }


}

