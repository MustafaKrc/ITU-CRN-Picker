import QtQuick 2.0

import "../"

Item {
    id: snapIndicator
    property int gap: 10
    property int snapPosition: Enums.SnapPosition.None
    visible: snapPosition !== Enums.SnapPosition.None

    property int borderWidth: 5

    property color borderColor: "#cf060627"
    property color backgroundColor: "#822a2828"


    Rectangle {
        id: mainRect
        color: backgroundColor
        radius: 5
        border.color: borderColor
        border.width: borderWidth
        anchors.fill: parent

        Rectangle {
            id: bottomLeft
            x: -8
            y: -8
            width: parent.width/2 - 2 * gap
            height: parent.height/2 - 2*gap
            color: backgroundColor
            radius: 5
            border.color: borderColor
            border.width: borderWidth
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: gap
            anchors.bottomMargin: gap

            visible: snapPosition === Enums.SnapPosition.BottomLeft
        }

        Rectangle {
            id: wholeLeft
            x: 10
            y: 10
            width: parent.width/2 - 2 * gap
            color: backgroundColor
            radius: 5
            border.color: borderColor
            border.width: borderWidth
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2 * gap
            anchors.leftMargin: gap
            anchors.topMargin: 2 * gap

            visible: snapPosition === Enums.SnapPosition.Left
        }

        Rectangle {
            id: wholeRight
            x: 10
            width: parent.width/2 - 2 * gap
            color: backgroundColor
            radius: 5
            border.color: borderColor
            border.width: borderWidth
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2 * gap
            anchors.topMargin: gap * 2
            anchors.rightMargin: gap

            visible: snapPosition === Enums.SnapPosition.Right
        }

        Rectangle {
            id: topLeft
            x: 10
            y: 10
            width: parent.width/2 - 2 * gap
            height: parent.height / 2 - 2*gap
            color: backgroundColor
            radius: 5
            border.color: borderColor
            border.width: borderWidth
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: gap
            anchors.topMargin: gap

            visible: snapPosition === Enums.SnapPosition.TopLeft
        }

        Rectangle {
            id: topRight
            x: 330
            y: 10
            width: parent.width/2 - 2 * gap
            height: parent.height / 2 - 2 * gap
            color: backgroundColor
            radius: 5
            border.color: borderColor
            border.width: borderWidth
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: gap
            anchors.rightMargin: gap

            visible: snapPosition === Enums.SnapPosition.TopRight
        }

        Rectangle {
            id: bottomRight
            x: 330
            y: 250
            width: parent.width/2 - 2 * gap
            height: parent.height/2 - 2*gap
            color: backgroundColor
            radius: 5
            border.color: borderColor
            border.width: borderWidth
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: gap
            anchors.rightMargin: gap

            visible: snapPosition === Enums.SnapPosition.BottomRight
        }

        Rectangle {
            id: fullscreen
            x: 20
            y: 20
            color: backgroundColor
            radius: 5
            border.color: borderColor
            border.width: borderWidth
            anchors.fill: parent
            anchors.rightMargin: 2 * gap
            anchors.leftMargin: 2 * gap
            anchors.bottomMargin: 2 * gap
            anchors.topMargin: 2 * gap

            visible: snapPosition === Enums.SnapPosition.Top
        }


    }

}
