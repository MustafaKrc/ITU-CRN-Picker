import QtQuick 2.15
import QtQuick.Controls

import "../controls"

import core.UserConfig 1.0

Flickable {

    property var notifier: undefined

    property color backgroundColor: "#2c313c"
    property color secondaryColor: "#1f222a"
    property color textColor: "#ffffff"

    Rectangle {
        id: background
        color: "#2c313c"
        anchors.fill: parent
    }

    contentHeight: settingHeader.height + settingHeader.anchors.topMargin + settingHeader.anchors.bottomMargin +
                   settings.implicitHeight + settings.anchors.bottomMargin + settings.anchors.topMargin


    Rectangle {
        id: settingHeader
        width: settingHeaderText.implicitWidth + 6 * settingHeaderText.anchors.margins
        height: settingHeaderText.implicitHeight + 3 * settingHeaderText.anchors.margins
        color: secondaryColor
        radius: 22
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.leftMargin: 75

        Text {
            id: settingHeaderText
            width: 205
            color: textColor
            text: qsTr("Settings")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 35
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 5
        }
    }

    
    Column {
        id: settings
        anchors.top : settingHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 25
        anchors.rightMargin: 25
        anchors.leftMargin: 100
        anchors.bottomMargin: 50
        anchors.topMargin: 50
        
        SettingSwitchButton {
            id: rememberMe
            width: parent.width
            buttonToTextRatio: 0.6
            settingText: "Remember username and password on each login."
            spacing: 25

            value: UserConfig.rememberMe
            binderFunction: function(parent){UserConfig.rememberMe = !UserConfig.rememberMe;}

        }

        SettingSwitchButton {
            id: keepMeSignedIn
            width: parent.width
            buttonToTextRatio: 0.6
            settingText: "Automatically log into my account everytime application is run."
            spacing: 25

            value: UserConfig.keepMeSignedIn
            binderFunction: function(parent){UserConfig.keepMeSignedIn = !UserConfig.keepMeSignedIn;}
        }

        SettingInputBox {
            id: requestInterval
            width: parent.width
            settingText: "Amount of seconds between each post request to server."
            spacing: 25
            inputValidator: SettingInputBox.Validator.Double
            minimum: 1.1
            inputToDescWidthRatio: 0.35
            value: UserConfig.requestInterval
            binderFunction: function(parent){UserConfig.requestInterval = parent.text;}

            //order: SettingInputBox.Order.DescriptionFirst
        }

        SettingInputBox {
            id: maxRequestCount
            width: parent.width
            settingText: "Maximum amount of request to make. (Type -1 for unlimited)"
            spacing: 25
            inputValidator: SettingInputBox.Validator.Integer
            minimum: 1
            edgeCase: -1
            inputToDescWidthRatio: 0.35
            value: UserConfig.maxRequestCount
            binderFunction: function(parent){UserConfig.maxRequestCount = parent.text;}
        }

        Rectangle {
            id: advancedSeperator
            width: advancedSeperatorText.implicitWidth + 6 * advancedSeperatorText.anchors.margins
            height: advancedSeperatorText.implicitHeight + 3 * advancedSeperatorText.anchors.margins
            color: secondaryColor
            radius: 22

            Text {
                id: advancedSeperatorText
                width: 205
                color: textColor
                text: qsTr("Advanced")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 5
            }
        }

        SettingInputBox {
            id: authTokenRefreshInterval
            width: parent.width
            settingText: "Amount of seconds to refresh authorization token."
            spacing: 25
            inputValidator: SettingInputBox.Validator.Integer
            minimum: 3600
            maximum: 21600
            inputToDescWidthRatio: 0.35
            value: UserConfig.tokenRefreshInterval
            binderFunction: function(parent){UserConfig.tokenRefreshInterval = parent.text;}
        }
    }
}




