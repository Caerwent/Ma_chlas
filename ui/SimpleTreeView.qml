import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0
Rectangle {
   width: 600
   height: 600
   color: "black"
   ListModel {
      id: objModel
   }
   Component {
      id: objRecursiveDelegate
      Column {
         id: objRecursiveColumn
         clip: true
         MouseArea {
            width: objRow.implicitWidth
            height: objRow.implicitHeight 
            onDoubleClicked: {
               for(var i = 1; i < parent.children.length - 1; ++i) {
                  parent.children[i].visible = !parent.children[i].visible
               }
            }
            Row {
               id: objRow
               Item {
                  height: 1
                  width: model.level * 20
               }
               Text {
                  text: (objRecursiveColumn.children.length > 2 ?
                           objRecursiveColumn.children[1].visible ?
                           qsTr("-  ") : qsTr("+ ") : qsTr("   ")) + model.name
                  color: objRecursiveColumn.children.length > 2 ? "blue" : "yellow"
                  font { bold: true; pixelSize: 14 }
               }
            }
         }
         Repeater {
            model: subNode
            delegate: objRecursiveDelegate
         }
      }
   }
   ColumnLayout {
      anchors.fill: parent
      ListView {
         Layout.fillHeight: true
         Layout.fillWidth: true
         model: objModel
         delegate: objRecursiveDelegate
      }
      Window {
         id: objModalInput
         modality: Qt.ApplicationModal
         visible: false
         height: 30
         width: 200
         color: "yellow"
         TextInput {
            anchors.fill: parent
            font { bold: true; pixelSize: 20 }
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment: TextInput.AlignHCenter
            validator: RegExpValidator {
               regExp: /(\d{1,},)*.{1,}/
            }
            onFocusChanged: {
               if(focus) {
                  selectAll()
               }
            }
            text: qsTr("node0")
            onAccepted: {
               if(acceptableInput) {
                  objModalInput.close()
                  var szSplit = text.split(',')
                  if(szSplit.length === 1) {
                     objModel.append({"name": szSplit[0], "level": 0, "subNode": []})
                  }
                  else {
                     if(objModel.get(parseInt(szSplit[0])) === undefined) {
                        console.log("Error - Given node does not exist !")
                        return
                     }
                     var node = objModel.get(parseInt(szSplit[0]))
                     for(var i = 1; i < szSplit.length - 1; ++i) {
                        if(node.subNode.get(parseInt(szSplit[i])) === undefined) {
                           console.log("Error - Given node does not exist !")
                           return
                        }
                        node = node.subNode.get(parseInt(szSplit[i]))
                     }
                     node.subNode.append({"name": szSplit[i], "level": i, "subNode": []})
                  }
               }
            }
         }
      }
      Button { 
         text: "add data to tree" 
         onClicked: {
            objModalInput.show()
         }
      }
   }
}