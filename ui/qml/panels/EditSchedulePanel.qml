import QtQuick 2.15
import QtQuick.Layouts

import "../controls"

Item {
    property color shadowColor: "#ad111219"
    property color panelColor: "#1f222a"
    property color textColor: "#ffffff"
    property color panelSecondaryColor: "#2c313c"

    property color inputSelectionColor: "#64769e"

    Rectangle {
        id: shadow
        color: shadowColor
        anchors.fill: parent

        Rectangle {
            id: editSchedulePanel
            color: panelColor
            radius: 25
            anchors.fill: parent
            anchors.rightMargin: 50
            anchors.leftMargin: 50
            anchors.bottomMargin: 50
            anchors.topMargin: 50

            ColumnLayout {
                id: schedule
                anchors.fill: parent
                anchors.rightMargin: 50
                anchors.leftMargin: 50
                anchors.bottomMargin: 25
                anchors.topMargin: 25

                RowLayout {
                    id: name
                    height: 400
                    Layout.preferredHeight: 75
                    Layout.fillWidth: true
                    spacing: 15

                    Text {
                        id: nameText
                        color: textColor
                        text: qsTr("Schedule Name:")
                        font.pixelSize: 20
                    }

                    TextInput {
                        id: nameInput

                        height: 20
                        color: textColor
                        text: qsTr("Text Input")
                        font.pixelSize: 20
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        clip: true
                        selectionColor: inputSelectionColor
                        selectByMouse: true

                        Layout.maximumHeight: 75
                    }
                }

                RowLayout {
                    id: ecrn
                    height: 400
                    Layout.preferredHeight: 75
                    Layout.fillWidth: true
                    spacing: 15

                    Text {
                        id: ecrnText
                        color: textColor
                        text: qsTr("Course CRNs to be Picked:")
                        font.pixelSize: 20
                    }

                    TextInput {
                        id: ecrnInput
                        width: implicitWidth
                        height: 20
                        color: textColor
                        text: qsTr("Text Input")
                        font.pixelSize: 20
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        clip: true
                        selectionColor: inputSelectionColor
                        selectByMouse: true
                        Layout.maximumHeight: 75
                    }
                }

                RowLayout {
                    id: scrn
                    height: 400
                    Layout.preferredHeight: 75
                    Layout.fillWidth: true
                    spacing: 15

                    Text {
                        id: scrnText
                        color: textColor
                        text: qsTr("Course CRNs to be dropped:")
                        font.pixelSize: 20
                    }

                    TextInput {
                        id: scrnInput
                        width: implicitWidth
                        height: 20
                        color: textColor
                        text: qsTr("Text Input")
                        font.pixelSize: 20
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        clip: true
                        selectionColor: inputSelectionColor
                        selectByMouse: true
                        Layout.maximumHeight: 75
                    }
                }

                RowLayout {
                    id: buttons
                    width: 100
                    height: 100
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true
                    spacing: 15

                    CustomButton {
                        id: save
                        text: "Save"
                        colorPressed: "#009b23"
                        colorMouseOver: "#00d22f"
                        colorDefault: "#009b23"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 50
                        Layout.preferredWidth: 75
                        Layout.fillWidth: false
                        Layout.fillHeight: false
                    }

                    CustomButton {
                        id: cancel
                        text: "Cancel"
                        colorMouseOver: "#f90000"
                        colorPressed: "#bd0000"
                        colorDefault: "#bd0000"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 50
                        Layout.preferredWidth: 75

                    }
                }
            }
        }
    }
}
