import QtQuick 2.15
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts



RowLayout{
    id: settingRow

    // properties
    property color buttonColorDefault: "#1c1d20"
    property color buttonColorMouseOver: "#1c1d20"
    property bool isEnabled: false // enabled başka var galiba ama bulamadım
    property string settingText: "placeholder text"
    property color settingTextColor: "#ffffff"


    Rectangle {

        property bool hovered: false
        MouseArea{
            id: mousearea
            anchors.fill: parent
            onClicked: settingRow.isEnabled = !settingRow.isEnabled
            hoverEnabled: true
            onEntered: buttonSwitch.hovered = true
            onExited: buttonSwitch.hovered = false
        }

        id: buttonSwitch

        width: 30
        height: 15

        visible: true
        color: buttonSwitch.hovered ? buttonColorMouseOver : buttonColorDefault
        clip: false
        radius: 25
        Layout.minimumHeight: 15
        Layout.fillHeight: true

        implicitWidth: height * 2

        Rectangle{
            id: circle
            x: 6
            width: parent.height * 0.8
            height: parent.height * 0.8
            radius: height / 2
            anchors.verticalCenter: parent.verticalCenter
            state: "off state"
            anchors.verticalCenterOffset: 0
        }
    }


    states: [
        State {
            name: "On State"
            when: settingRow.isEnabled

            PropertyChanges {
                target: circle
                x: buttonSwitch.width - width - 6
                color: "#14a901"
            }
        }
    ]

    transitions: [
        Transition {
        from: ""; to: "On State"; reversible: true
        ParallelAnimation {
            NumberAnimation { properties: "x"; duration: 500; easing.type: Easing.InOutQuad }
            ColorAnimation { duration: 500 }
        }
    }
]





    Text {
        id: textDescription
        text: settingText

        font.pixelSize: 12
        Layout.minimumHeight: 12
        Layout.fillWidth: true
        color: settingTextColor
    }

}
