import QtQuick 2.15
import QtQuick.Controls

Item {
    Rectangle {
        id: rectangle
        color: "#2c313c"
        anchors.fill: parent

        Label {
            id: label
            color: "#ffffff"
            text: qsTr("Home Page")
            anchors.verticalCenter: parent.verticalCenter
            font.family: "15"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

}
