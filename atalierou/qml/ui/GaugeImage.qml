import QtQuick
import QtQuick.Controls

//Draw an image where all pixels except transparent will be colored to a given color
Item {
    id:coloredImg
    property color overlayEmptyColor: Material.backgroundDimColor
    property color overlayFullColor: Material.foreground
    property real fillPercent: 0
    property alias source: img.source
    property bool hoverEnabled: true
    property bool isAnimated:true

    signal clicked
    signal fillAnimationEnded

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

    Canvas {

        id: gaugeMask
        height: parent.height
        width: parent.width
        property real animatedfillPercent: fillPercent
        onPaint: {
            var ctx = getContext("2d");
            var h=parent.height * (100-animatedfillPercent) /100
            ctx.fillStyle = overlayEmptyColor
            ctx.fillRect(0, 0, width, h);
            ctx.fillStyle = overlayFullColor
            ctx.fillRect(0, h, width, parent.height -h);
        }
        visible: false; // should not be visible on screen.
        layer.enabled: true;
        layer.smooth: true

        onAnimatedfillPercentChanged: {
            gaugeMask.requestPaint()
            if(animatedfillPercent===fillPercent)
                fillAnimationEnded()
        }

        Behavior on animatedfillPercent {
            NumberAnimation {
                duration: isAnimated ? 1000 : 0

            }
        }
    }
    Image {
        id: img
        height: parent.height
        width: parent.width
        enabled: coloredImg.enabled
        sourceSize: Qt.size(parent.width, parent.height)
        //antialiasing: true
        smooth: true
        layer.enabled: true
        // This item should be used as the 'mask'
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            property var colorSource: gaugeMask;
            fragmentShader: "qrc:/res/shaders/maskSourceFrag.qsb"
        }
    }

    MouseArea {
        id:mouseArea
        enabled: coloredImg.enabled
        anchors.fill: parent
        hoverEnabled: coloredImg.hoverEnabled
        onEntered:{
            //shader.overlayColor = Material.accent
        }

        onExited :{
            //shader.overlayColor=coloredImg.overlayColor
        }

        onClicked: {
            coloredImg.clicked()
        }
    }
}
