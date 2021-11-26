import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."


Item {
        property string label
        property string imgSource
        property bool selectable:false
        property int padding : 10
        signal selected()
        Rectangle {
            width: (parent.width-padding*UIUtils.UI.dp)
            height: (parent.height-padding*UIUtils.UI.dp)
            anchors.horizontalCenter: parent.horizontalCenter
             anchors.verticalCenter: parent.verticalCenter
            border.color:Material.primary
            border.width: 2*UIUtils.UI.dp
            radius: 10*UIUtils.UI.dp
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
        Column {
            width: (parent.width-padding*UIUtils.UI.dp)
            height: (parent.height-padding*UIUtils.UI.dp)
            anchors.horizontalCenter: parent.horizontalCenter
             anchors.verticalCenter: parent.verticalCenter
            spacing: 2*UIUtils.UI.dp
            Label {
                text: label ? label : ""
                color:Material.primary
                width: (parent.width-padding*UIUtils.UI.dp)
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: isSmall ? 8 : 16
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
            }
            Image {

                source: imgSource ? imgSource : ""

                width: (parent.width-padding*UIUtils.UI.dp)
             //   height: (childrenGrid.cellWidth-20*UIUtils.UI.dp)
                anchors.horizontalCenter: parent.horizontalCenter

                sourceSize: Qt.size(width, height)
            }



           }
        }

    }

