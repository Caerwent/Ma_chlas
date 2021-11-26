
import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."

Frame {

    function gotToScreen(screenRef, params) {
        try{

            var component = Qt.createComponent(screenRef);
            if(component.status===Component.Error )
            {
                console.log ("Component creation error :", component.errorString() );
                throw ( new Error("Component is null"))
            }
            else
            {
                var incubator = component.incubateObject(mainStack, params ? params : {});
                if (incubator.status !== Component.Ready) {
                    incubator.onStatusChanged = function(incubatorStatus) {
                        if (incubatorStatus === Component.Ready) {
                            console.log ("Object", incubator.object, "is now ready!");
                            App.instance.getStack().push(incubator.object)
                        }
                        else if(incubatorStatus === Component.Error )
                        {
                            console.log ("Object", " error ", incubator.errorString())
                        }
                    }
                } else {
                    console.log ("Object", incubator.object, "is ready immediately!");
                    App.instance.getStack().push(incubator.object)
                }
            }

        }catch(error)
        {
            App.instance.errorDialog.showError(qsTr("Error when displaying screen %1 : %2\n%3").arg(screenRef).arg(error).arg(error.stack))
        }
    }

    function back()
    {
        App.instance.getStack().pop()
    }


    ColoredImage {
        id: back
        visible: App.instance.getStack().depth>1
        source: "qrc:///res/icons/back.svg"
        width: 40*UIUtils.UI.dp
        height: 40*UIUtils.UI.dp

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10*UIUtils.UI.dp
        anchors.topMargin: 10*UIUtils.UI.dp
        anchors.rightMargin: 10*UIUtils.UI.dp
        anchors.bottomMargin: 10*UIUtils.UI.dp

        MouseArea {
            anchors.fill: parent
            onClicked: {
                navigator.back()
            }
        }
    }


    ColoredImage {
        id: exit
        source: "qrc:///res/icons/exit.svg"
        width: 40*UIUtils.UI.dp
        height: 40*UIUtils.UI.dp
        visible: App.instance.getStack().depth<=1
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10*UIUtils.UI.dp
        anchors.topMargin: 10*UIUtils.UI.dp
        anchors.rightMargin: 10*UIUtils.UI.dp
        anchors.bottomMargin: 10*UIUtils.UI.dp
        MouseArea {
            anchors.fill: parent
            onClicked: {
                Qt.quit()
            }
        }
    }

}
