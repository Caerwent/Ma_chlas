import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Dialogs
import UIUtils 1.0 as UIUtils
import "."
import "../components"
import "../dataModels"
Window {
    color: Material.background
    visibility: "FullScreen"
   // width:1145
   // height:845
    visible:true
    title: qsTr("Ma c'hlass atalieroù")

    property alias state : windowContent.state


    Dialog {
        id:error

        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            horizontalAlignment: "AlignHCenter"
            id:errorMessage

        }
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        onAccepted: {
            Qt.quit()
        }

        function showError(amsg)
        {
            errorMessage.text = amsg
            visible = true
        }
    }

    Dialog {
        id:warning

        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            horizontalAlignment: "AlignHCenter"
            id:warningMessage

        }
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        onAccepted: {
        }

        function showWarning(amsg)
        {
            warningMessage.text = amsg
            visible = true
        }
    }

    Dialog {
        id:info

        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            horizontalAlignment: "AlignHCenter"
            id:infoMessage

        }
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        onAccepted: {

        }

        function showMessage(amsg)
        {
            infoMessage.text = amsg
            visible = true
        }
    }

    Item{
        id:windowContent
        anchors.fill: parent
        state: "landscape"
        states: [
            State {
                name: "landscape"
                AnchorChanges {
                    target: navigator
                    anchors.bottom: parent.bottom
                    anchors.right:undefined

                }
                PropertyChanges {
                    target: navigator
                    width:70*UIUtils.UI.dp
                    state:"landscape"
                }
                AnchorChanges {
                    target: mainStack
                    anchors.left: navigator.right
                    anchors.top: parent.top

                }
            },
            State {
                name: "portrait"
                AnchorChanges {
                    target: navigator
                    anchors.right: parent.right
                    anchors.bottom:undefined
                }
                PropertyChanges {
                    target: navigator
                    height:70*UIUtils.UI.dp
                    state:"portrait"
                }
                AnchorChanges {
                    target: mainStack
                    anchors.left: parent.left
                    anchors.top: navigator.bottom

                }
            }
        ]

        function checkSize() {
            if(width<height)
            {
                state="portrait"
            } else {
                state="landscape"
            }
        }

        onWidthChanged: {
            checkSize()
        }
        onHeightChanged: {
            checkSize()
        }


        Navigator {
            id: navigator
                anchors.left: parent.left
                anchors.top: parent.top
            }

        StackView {
            id: mainStack
            focus: true // important - otherwise we'll get no key events
            initialItem: "qrc:/qml/main/home.qml"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            Keys.onBackPressed: {
                if(depth<=1)
                {
                    Qt.quit()
                }
                else
                {
                    navigator.back()
                }
            }
        }

    }

    function getNavigator()
    {
        return navigator
    }

    function getStack()
    {
        return mainStack
    }

    function showError(amsg)
    {
        error.showError(amsg)
    }

    function showWarning(amsg)
    {
        warning.showWarning(amsg)
    }

    function showMessage(amsg)
    {
        info.showMessage(amsg)
    }


    Component.onCompleted:
    {
        App.instance = applicationWindow
        Session.screens.push(Screens.home)
    }

}
