import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../components"
import "../dataModels"
import QtQuick.Particles

ScreenTemplate {
    id:childrenComponent

    titleText: qsTr("Score")
    AppScrollView {
        id:screen
        anchors.fill: parent
        anchors.topMargin: 20*UIUtils.UI.dp
    Item {
        id:childrenFrame
        anchors.fill: parent

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

            Accessible.role: Accessible.StaticText
            Accessible.name: qsTr("accessible.score_%1").arg(fillPercent)

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

            Accessible.role: Accessible.Button
            Accessible.name: qsTr("accessible.nav_back")
            Accessible.onPressAction: {
                App.instance.getNavigator().back()
            }
        }
        }

}







    }


}

