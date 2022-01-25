import QtQuick
import QtQuick.Controls

//Draw an image where all pixels except transparent will be colored to a given color
Item {
    id:coloredImg
    property color overlayColor: Material.foreground
    property alias source: img.source
    property bool hoverEnabled: true

    signal clicked

    onEnabledChanged:
    {
        if(enabled)
        {
            mouseArea.hoverEnabled = coloredImg.hoverEnabled
            shader.overlayColor=coloredImg.overlayColor
        }
        else
        {
            mouseArea.hoverEnabled = false
            shader.overlayColor=Material.buttonDisabledColor
        }
    }

    Image {
        id: img
        height: parent.height
        width: parent.width
        enabled: coloredImg.enabled
        sourceSize: Qt.size(width, height)
        //antialiasing: true
        smooth: true
        visible: false
    }
    ShaderEffect {
        id:shader
        property color overlayColor: coloredImg.overlayColor
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
        id:mouseArea
        enabled: coloredImg.enabled
           anchors.fill: parent
           hoverEnabled: coloredImg.hoverEnabled
           onEntered:{
               shader.overlayColor = Material.accent
           }

           onExited :{
               shader.overlayColor=coloredImg.overlayColor
           }

           onClicked: {
               coloredImg.clicked()
           }
       }
}
