import QtQuick 2.0
import QtQuick.Layouts

Item {
    id: root

    property var parentIndex
    property var childCount
    property int itemLeftPadding: 30
    property var treeModel
    implicitWidth: parent.width
    implicitHeight: childrenRect.height

    ColumnLayout {
        width: parent.width
        spacing: 10

        Repeater {
            id:childRepeater
            model: childCount

            delegate: ColumnLayout {
                id: itemColumn

                Layout.fillWidth: true
                Layout.leftMargin: itemLeftPadding

                spacing: 10

                QtObject {
                    id: _d

                    property var currentIndex: treeModel.index(index, 0, parentIndex)
                    property var currentData: treeModel.data(currentIndex, 0)
                    property var itemChildCount: treeModel.rowCount(currentIndex)
                    property bool isOpen: false
                }

                Row {
                    spacing: 10
                    width: parent.width

                    MouseArea {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 15
                        height: 15
                        onClicked: _d.isOpen = !_d.isOpen

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 15
                            height: 3
                            color: "#3c85b5"
                            opacity: _d.itemChildCount > 0 ? 1.0 : 0.0

                            Rectangle {
                                anchors.centerIn: parent
                                width: 3
                                height: 15
                                color: "#3c85b5"
                                visible: !_d.isOpen
                            }
                        }
                    }

                    Row {
                        id: modelItem

                        property alias content: contentData.text

                        spacing: 10

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 20
                            height: 20
                            color: "#3c85b5"
                        }

                        Text {
                            id: contentData
                            text:contentData.text
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#3c85b5"
                            font.pixelSize: 20
                        }
                    }


                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin:  -100

                    height: 1
                    color: "gray"
                    opacity: 0.5
                }

                Loader {
                    width: parent.width

                    visible: _d.isOpen
                    source: "TreeItem.qml"
                    onLoaded: {
                        item.parentIndex = _d.currentIndex
                        item.childCount = _d.itemChildCount
                        item.treeModel=treeModel
                    }
                }
            }
        }
    }
}

