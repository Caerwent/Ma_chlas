import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."


Rectangle {
    id:root
        property string label
        property int labelSize :16
        property string imgSource
        property bool selectable:false
        property int padding : 10
        property var bkgColor:Material.primaryColor

        signal selected()

    border.color:Material.primary
    border.width: 2*UIUtils.UI.dp
    radius: 10*UIUtils.UI.dp
    color:bkgColor


            MouseArea {
                   anchors.fill: parent
                   hoverEnabled: selectable
                   onEntered:{
                       parent.border.color = Material.accent
                   }

                   onExited :{
                       parent.border.color = Material.primary
                   }
                   onClicked: {
                       if(selectable)
                       {
                        selected()
                       }
                   }
               }

            Label {
                id:cardLabel
                text: label ? label : ""
                color:Material.primaryTextColor
                width: Math.min(implicitWidth, (parent.width-2*padding*UIUtils.UI.dp - 2*root.border.width))
                anchors.top: parent.top
                anchors.topMargin: padding*UIUtils.UI.dp+2*root.border.width
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: labelSize
                horizontalAlignment: Text.AlignHCenter
                rightInset: 3*UIUtils.UI.dp
                leftInset: 3*UIUtils.UI.dp
                wrapMode: Text.Wrap
                background: Rectangle {
                    anchors.fill: cardLabel
                    color:Material.backgroundColor
                    radius: 3*UIUtils.UI.dp
                }
            }
            Image {
                width: (parent.width-2*padding*UIUtils.UI.dp-2*root.border.width)
                height:(parent.height-2*padding*UIUtils.UI.dp-labelSize*UIUtils.UI.dp-root.border.width)
                source: imgSource ? imgSource : ""
                anchors.top: parent.top

                fillMode: Image.PreserveAspectFit
                anchors.topMargin: padding*UIUtils.UI.dp+labelSize*UIUtils.UI.dp+root.border.width
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize: Qt.size(width, height)
            }






    }

