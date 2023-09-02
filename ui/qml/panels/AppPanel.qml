import QtQuick 2.15

Item {
    id: appPanel
    property color backgroundColor: "#1f3a62"
    property color textColor: "#ffffff"
    property color secondaryColor: "#1f222a"

    Rectangle {
        id: background
        color: backgroundColor
        anchors.fill: parent
    }

    Rectangle {
        id: scheduleHeader
        width: scheduleHeaderText.implicitWidth + 6 * scheduleHeaderText.anchors.margins
        height: scheduleHeaderText.implicitHeight + 3 * scheduleHeaderText.anchors.margins
        color: appPanel.secondaryColor
        radius: 22
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.leftMargin: 75

        Text {
            id: scheduleHeaderText
            width: 205
            color: appPanel.textColor
            text: qsTr("Current Schedule")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 5
        }
    }




}
