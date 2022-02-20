import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."

Item {
    property string titleText: ""

    default property alias children: objectContainer.children

    Label {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        id: title
        text: titleText
        anchors.topMargin: 20*UIUtils.UI.dp
        anchors.leftMargin: 20*UIUtils.UI.dp
        anchors.rightMargin: 20*UIUtils.UI.dp
        font.pointSize: 20
    }



        Rectangle {
            id:objectContainer

            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 40*UIUtils.UI.dp
            anchors.topMargin: 40*UIUtils.UI.dp
            anchors.rightMargin: 40*UIUtils.UI.dp
            anchors.bottomMargin: 40*UIUtils.UI.dp
            color:Material.backgroundColor

            onChildrenChanged: {
                console.log("width:"+width+" height="+height)
            }
        }



}
