import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils

import FileIO 1.0
Component {
    id:phonemComponent

    Rectangle {
        FileIO {
            id:configFile
            source:"./data/config.json"
            onError: msg => console.log(msg)
        }
            Component.onCompleted: {

                var response = configFile.read();
                var JsonObject= JSON.parse(response);
                phonem1.dataPath=JsonObject.path;
                phonem1.phonemData=JsonObject.phonems[1].items[0];
            }

    Phonem {
        id: phonem1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: -1
        anchors.leftMargin: 0
        anchors.topMargin: 0

    }
}

}
