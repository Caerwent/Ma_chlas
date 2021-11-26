import QtQuick 2.0
import QtQuick.Controls 2.5
import UIUtils 1.0 as UIUtils
import "data/loadJson.js" as DataHelper
Item {
    Phonem {
        id: phonem1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: -1
        anchors.leftMargin: 0
        anchors.topMargin: 0

    }

    Button {
        id: btn1
        text: qsTr("Btn1")
        anchors.top: phonem1.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        onClicked: DataHelper.loadJSON("config.json", (response) => {
                                           phonem1.phonemData=response.phonems[1].items[0]
                                       })
    }


}
