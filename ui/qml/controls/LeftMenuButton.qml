import QtQuick 2.15
import QtQuick.Controls 6.3
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material

Button {

    id: buttonLeftMenu
    text: qsTr("Left Menu Text")

    // custom properties
    property url buttonIconSource: "../../images/svg_images/home_icon.svg"
    property color buttonColorDefault: "#1c1d20"
    property color buttonColorMouseOver: "#23262e"
    property color buttonColorClicked: "#00a1f1"
    property int iconWidth: 18
    property int iconHeight: 18
    property color activeMenuColor: "#55aaff"
    property color activeMenuColorRight: "#2c313b"
    property bool isActiveMenu: true

    visible: true

    QtObject{
        id: internal

        property var dynamicColor: if(buttonLeftMenu.down){
                                       buttonLeftMenu.down ? buttonColorClicked : buttonColorDefault
                                   } else {
                                       buttonLeftMenu.hovered ? buttonColorMouseOver : buttonColorDefault
                                   }
    }

    implicitWidth: 250
    implicitHeight: 60

    background: Rectangle{
        id: backgroundButton
        color: internal.dynamicColor
        anchors.fill: parent

        Rectangle{
            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
            color: activeMenuColor
            width: 3
            visible: isActiveMenu
        }

        Rectangle{
            anchors{
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            color: activeMenuColorRight
            width: 5
            visible: isActiveMenu
        }
    }

    contentItem: Item{
        id: content
        anchors.fill: parent

        Image{
            id: iconButton
            source: buttonIconSource
            anchors.leftMargin: 26
            sourceSize.width: iconWidth
            sourceSize.height: iconHeight
            height: iconHeight
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            width: iconWidth
            fillMode: Image.PreserveAspectFit
            antialiasing: true
        }

        ColorOverlay{
            visible: true
            anchors.fill: iconButton
            source: iconButton
            color: "#ffffff"
            antialiasing: true
        }

        Text{
            color: "#ffffff"
            text: buttonLeftMenu.text
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            font.pointSize: 10
            anchors.leftMargin: 75
        }
    }



}
