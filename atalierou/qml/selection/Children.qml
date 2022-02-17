import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "../main"
import "../components"
import "../dataModels"

ScreenTemplate {
    id: childrenComponent

    titleText: qsTr("Children")

    Item {
        id:screen
        anchors.fill: parent

    ListModel {
        id: childrenModel
    }

    Component {
        id: childrenDelegate
        Avatar {
            width: childrenGrid.cellWidth- 10*UIUtils.UI.dp
            height: childrenGrid.cellHeight- 10*UIUtils.UI.dp
            child: childRef
            isSelectable: true
            onSelected: {
                Session.loadUser(indexChild)
                App.instance.getNavigator().gotToScreen(
                            Screens.activitiesGroupChoice)
            }
            padding:10*UIUtils.UI.dp
            Accessible.role: Accessible.Button
            Accessible.name: child ? child.name : ""
            Accessible.onPressAction: {
                   selected()
               }
        }
    }

    GridView {
        id: childrenGrid
        interactive: false
        anchors.fill: parent
        cellWidth: 100 * UIUtils.UI.dp
        cellHeight: 100 * UIUtils.UI.dp
        flow: GridView.FlowLeftToRight
        model: childrenModel
        delegate: childrenDelegate
        focus: true
    }

    function updateFromConfig() {
        childrenModel.clear()
        console.log("children updateFromConfig")
        var childrenList = Session.group.children
        for (var i in childrenList) {
            childrenModel.append({
                                     "indexChild": i,
                                     "childRef": childrenList[i]
                                 })
        }
    }

    Component.onCompleted: {
        screen.updateFromConfig()
    }
    }
}
