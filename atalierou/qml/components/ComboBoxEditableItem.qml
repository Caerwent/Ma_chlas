import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils


ComboBox {
    id: root

    delegate: Row {
        required property string itemName
        required property bool needToBeSaved
        ColoredImage {
            id:modifiedIconItem
            source: "qrc:/res/icons/action_edit.svg"
            width: 10*UIUtils.UI.dp
            height: 10*UIUtils.UI.dp
            opacity:needToBeSave ? 1 : 0
            overlayColor: Material.accentColor
        }
        Text{
            id:eltText
            text: itemName
            color: Material.primaryTextColor

        }


    }
}
