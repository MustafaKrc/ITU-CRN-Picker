import QtQuick 2.15
import QtQuick.Controls
import Qt5Compat.GraphicalEffects



Item{
    id: setting
    // properties
    property color buttonColorDefault: "#1c1d20"
    property color buttonColorMouseOver: "#36373c"

    property real buttonToTextRatio: 1

    property bool value:false

    property string settingText: "placeholder text"
    property color settingTextColor: "#ffffff"

    property int switchButtonMaxSize: 100
    property int maximumTextSize: 60
    property int minimumTextSize: 12

    property int alignMode: SettingSwitchButton.Align.Left

    property int spacing: 5

    property var binderFunction : function(parent) {console.log(parent,"=> provide a binder function!")}

    width: 150
    height: 50


    Item{
        id: container
        anchors.centerIn: parent
        height: parent.height
        width: Math.min(parent.width,
                        alignMode === SettingSwitchButton.Align.Left ? parent.width
                                                                     : buttonSwitch.width
                                                                       + textDescription.paintedWidth
                                                                       + textDescription.anchors.leftMargin
                        )
        Rectangle {

            property bool hovered: false
            MouseArea{
                id: mousearea
                anchors.fill: parent
                onClicked: binderFunction()
                hoverEnabled: true
                activeFocusOnTab: true
                Keys.onSpacePressed: setting.value = !setting.value
                onEntered: buttonSwitch.hovered = true
                onExited: buttonSwitch.hovered = false
            }

            id: buttonSwitch


            anchors.verticalCenter: parent.verticalCenter


            height: Math.min(switchButtonMaxSize, parent.height * (buttonToTextRatio < 1 ? buttonToTextRatio : 1))
            width: height * 2
            visible: true
            color: buttonSwitch.hovered ? buttonColorMouseOver : buttonColorDefault
            radius: 25

            Rectangle{
                id: circle
                x: 6
                width: parent.height * 0.8
                height: parent.height * 0.8
                radius: height / 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 0
            }
        }

        Text {
            id: textDescription
            text: settingText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: buttonSwitch.right
            anchors.leftMargin: spacing

            width: Math.min(implicitWidth, setting.width - buttonSwitch.width - anchors.leftMargin)
            height: parent.height / (buttonToTextRatio > 1 ? buttonToTextRatio : 1)

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            wrapMode: Text.WordWrap
            color: settingTextColor
            fontSizeMode: Text.Fit

            font.pixelSize: Math.min(Math.max(minimumTextSize, container.height), maximumTextSize)
        }
    }

    enum Align{
        HorizontalCenter,
        Left
    }

    states: [
        State {
            name: "On State"
            when: setting.value

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

}
