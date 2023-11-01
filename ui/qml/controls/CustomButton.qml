import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Material

Button {
    id: button

    // Custom Properties
    property color colorDefault: "#4891d9"
    property color colorMouseOver: "#55AAFF"
    property color colorPressed: "#3F7EBD"

    property real minimumTextSize: 12

    QtObject{
        id: internal

        property var dynamicColor: if(button.down){
                                       button.down ? colorPressed : colorDefault
                                   }else{
                                       button.hovered ? colorMouseOver : colorDefault
                                   }
    }

    text: qsTr("Button")
    contentItem: Text {
        id: name
        text: button.text
        //font: button.font
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
        wrapMode: Text.WordWrap

        font.pixelSize: Math.max(height/2, minimumTextSize)

        //wrapMode: Text.WordWrap
    }

    background: Rectangle{
        color: internal.dynamicColor
        radius: 10
    }
}
