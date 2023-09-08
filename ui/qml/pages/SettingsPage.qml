import QtQuick 2.15
import QtQuick.Controls

import "../controls"

import core.UserConfig 1.0

Flickable {

    Rectangle {
        id: background
        color: "#2c313c"
        anchors.fill: parent
    }

    contentHeight: settings.implicitHeight + settings.anchors.bottomMargin + settings.anchors.topMargin

    ScrollBar.vertical: ScrollBar {
        parent: parent
    }

    
    Column {
        id: settings
        anchors.fill: parent
        spacing: 25
        anchors.rightMargin: 100
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
    }
}




