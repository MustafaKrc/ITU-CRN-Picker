import QtQuick 2.15
import QtQuick.Controls 6.3
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material

Button {

    id: buttonTopBar

    // properties
    property url buttonIconSource: "../../images/svg_images/minimize_icon.svg"
    property color buttonColorDefault: "#1c1d20"
    property color buttonColorMouseOver: "#23262e"
    property color buttonColorClicked: "#00a1f1"

    QtObject{
        id: internal

        property var dynamicColor: if(buttonTopBar.down){
                                       buttonTopBar.down ? buttonColorClicked : buttonColorDefault
                                   } else {
                                       buttonTopBar.hovered ? buttonColorMouseOver : buttonColorDefault
                                   }
    }

    implicitWidth: 35
    implicitHeight: 35

    background: Rectangle{
        id: backgroundButton
        color: internal.dynamicColor
        anchors.fill: parent
    }

    Image{
        id: iconButton
        source: buttonIconSource

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        height: 16
        width: 16
        fillMode: Image.PreserveAspectFit

    }

    ColorOverlay{
        anchors.fill: iconButton
        source: iconButton
        color: "#ffffff"
        antialiasing: false
    }

}
