import QtQuick 2.12
import QtQuick.Controls 2.2
import Qt5Compat.GraphicalEffects


Rectangle {
    id: root
    layer.enabled: shadowEnabled
    layer.effect: DropShadow{
        id: shadow
        cached: true
        radius: 8.0
        samples: 1+radius*2
        color: shadowColor
        verticalOffset: root.verticalOffset
        horizontalOffset: root.horizontalOffset
        spread: root.spread
    }

    color: "white"

    property bool shadowEnabled: true
    property color shadowColor: Qt.darker(root.color, 1.25)

    property real spread: 0.0
    property real verticalOffset: 0
    property real horizontalOffset: 0

    visible: false
    width: childrenRect.width
    height: 40
    radius: height/2

    property string text
    property string source
    property alias iconEnabled: notificationIcon.visible

    function open(notificationText, imageSource, notificationColor){
        opacityAnimation.stop();
        visible = true;
        opacity = 1;

        root.color = notificationColor
        text = notificationText;
        source = imageSource;

        timer.start();
    }

    Timer{
        id: timer
        interval: 2000

        onTriggered: {
            opacityAnimation.start();
        }
    }

    Row{
        width: childrenRect.width
        height: parent.height
        leftPadding: 10
        spacing: 10

        Image {
            id: notificationIcon
            source: root.source
            width: visible ? 25 : 0
            height: width
            sourceSize: Qt.size(width,height)
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            height: parent.height
            width: contentWidth + 20
            text: root.text
            color: "#ffffff"
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
        }

    }


    NumberAnimation{
        id: opacityAnimation
        target: root
        properties: "opacity"
        to: 0
        duration: 2000

        onStopped: {
            visible = false;
        }
    }

}
