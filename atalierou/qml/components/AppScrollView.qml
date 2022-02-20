import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils

ScrollView {
    id:root
    anchors.fill: parent
    anchors.topMargin: 20*UIUtils.UI.dp
    clip: true
    contentWidth:width

    ScrollBar.vertical: ScrollBar {
        id:scrollBar
        policy: ScrollBar.AsNeeded
        height: root.height        
        width: 10*UIUtils.UI.dp
        x:root.width-width

    }
    Keys.onUpPressed: scrollBar.decrease()
    Keys.onDownPressed: scrollBar.increase()
}
