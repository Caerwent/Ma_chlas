import QtQuick
import QtQuick.Controls

//Draw an image where all pixels except transparent will be colored to a given color
Item {

    property color overlayColor: Material.foreground
    property alias source: img.source
    Image {
        id: img
        height: parent.height
        width: parent.width
        sourceSize: Qt.size(width, height)
        //antialiasing: true
        smooth: true
        visible: false


    }
    ShaderEffect {

        property real r: overlayColor.r * overlayColor.a
        property real g: overlayColor.g * overlayColor.a
        property real b: overlayColor.b * overlayColor.a
        property variant src: img
        width: parent.width
        height: parent.height

        vertexShader: "qrc:/res/shaders/colorizeVert.qsb"

        fragmentShader: "qrc:/res/shaders/colorizeFrag.qsb"
    }
    MouseArea {
           anchors.fill: parent
           hoverEnabled: true
           onEntered:{
               overlayColor = Material.accent
           }

           onExited :{
               overlayColor = Material.foreground
           }
       }
}
