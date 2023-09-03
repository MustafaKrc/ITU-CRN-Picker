import QtQuick 2.15
import QtQuick.Controls

import "../controls"

Item {
    Rectangle {
        id: rectangle
        color: "#2c313c"
        anchors.fill: parent
    }

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        spacing: 25
        anchors.rightMargin: 50
        anchors.leftMargin: 50
        anchors.bottomMargin: 50
        anchors.topMargin: 50


        model: ListModel {
            ListElement {
                textSetting: "setting1"
            }

            ListElement {
                textSetting: "Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 Setting2 "
            }

            ListElement {
                textSetting: "Setting3"
            }

            ListElement {
                textSetting: "setting4"
            }
        }

        delegate: SettingSwitchButton{

            buttonColorDefault: "#20242d"

            settingText: textSetting
            isEnabled: true // will be fetched from UserConfig
            width: listView.width
            switchButtonMaxSize: 30

        }

    }
}




