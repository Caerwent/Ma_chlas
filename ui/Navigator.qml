
import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"
Flow {

    id:navigator
    property var child : Session.child

    flow: Flow.LeftToRight
    anchors.margins: 10*UIUtils.UI.dp
    spacing: 10*UIUtils.UI.dp

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
                            Session.screens.push(screenRef)
                        }
                        else if(incubatorStatus === Component.Error )
                        {
                            console.log ("Object", " error ", incubator.errorString())
                        }
                    }
                } else {
                    console.log ("Object", incubator.object, "is ready immediately!");
                    Session.screens.push(screenRef)
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

        Session.screens.pop()
        var currentItem = Session.screens[Session.screens.length-1]
        if(currentItem===Screens.children)
        {
            Session.child=undefined
        } else if(currentItem===Screens.home)
        {
            Session.classRoom=undefined
        }

    }


    ColoredImage {
        id: back
        visible: App.instance.getStack().depth>1
        source: "qrc:///res/icons/back.svg"
        width: 40*UIUtils.UI.dp
        height: 40*UIUtils.UI.dp


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

        MouseArea {
            anchors.fill: parent
            onClicked: {
                Qt.quit()
            }
        }
    }

    Avatar {
        id:avatar
        width: 60*UIUtils.UI.dp
        height: 60*UIUtils.UI.dp
        isSelectable:false
        visible:false
        isSmall:true
    }
    onChildChanged : {
        avatar.child = Session.child
        avatar.visible = (Session.child!==undefined)

    }

    state: "landscape"
    states: [
        State {
            name: "landscape"
            PropertyChanges {
                target: navigator
                flow: Flow.TopToBottom
            }

        },
        State {
            name: "portrait"
            PropertyChanges {
                target: navigator
                flow: Flow.LeftToRight
            }

        }
    ]
}
