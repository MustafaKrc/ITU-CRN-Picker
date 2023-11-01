import QtQuick 2.15
import QtQuick.Controls 6.3
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material

Button {

    id: buttonToggle

    // properties
    property url buttonIconSource: "../../images/svg_images/menu_icon.svg"
    property color buttonColorDefault: "#1c1d20"
    property color buttonColorMouseOver: "#23262e"
    property color buttonColorClicked: "#00a1f1"
    visible: true
    clip: false

    QtObject{
        id: internal

        property var dynamicColor: if(buttonToggle.down){
                                       buttonToggle.down ? buttonColorClicked : buttonColorDefault
                                   } else {
                                       buttonToggle.hovered ? buttonColorMouseOver : buttonColorDefault
                                   }
    }

    implicitWidth: 70
    implicitHeight: 60

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
        height: 25
        width: 25
        fillMode: Image.PreserveAspectFit

    }

    ColorOverlay{
        anchors.fill: iconButton
        source: iconButton
        color: "#ffffff"
        antialiasing: false
    }

}
