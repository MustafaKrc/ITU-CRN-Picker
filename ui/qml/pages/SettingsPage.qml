import QtQuick 2.15
import QtQuick.Controls

import "../controls"

import core.UserConfig 1.0


/*

    "login": {
        "rememberMe": "",
        "keepMeSignedIn": ""
    },
    "request": {
        "requestInterval": "",
        "maxRequestCount": "",


    },
    "token" : {
    },
    "schedule" : {
    }




  */



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


    //UserConfig
    
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

            isEnabled: UserConfig.getSetting("login","rememberMe").toLowerCase() === "true"
        }

        SettingSwitchButton {
            id: keepMeSignedIn
            width: parent.width
            buttonToTextRatio: 0.6
            settingText: "Automatically log into my account everytime application is run."
            spacing: 25

            isEnabled: UserConfig.getSetting("login","keepMeSignedIn").toLowerCase() === "true"
        }
        
        SettingInputBox {
            id: requestInterval
            width: parent.width
            settingText: "Amount of seconds between each post request to server."
            spacing: 25
            inputValidator: SettingInputBox.Validator.Double
            value: UserConfig.getSetting("request","requestInterval")
            minimum: 1.1
        }

        SettingInputBox {
            id: maxRequestCount
            width: parent.width
            settingText: "Maximum amount of request to make. (Type -1 for unlimited)"
            spacing: 25
            inputValidator: SettingInputBox.Validator.Integer
            value: UserConfig.getSetting("request","maxRequestCount")
            minimum: 1
            edgeCase: -1
        }




    }



    /*
    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        spacing: 25
        anchors.rightMargin: 50
        anchors.leftMargin: 50
        anchors.bottomMargin: 50
        anchors.topMargin: 50
        
        Component.onCompleted: console.log(userConfig.getSetting("login","rememberMe"))
        
        model: ListModel {
            ListElement {
                textSetting: "Remember Me"
                //value: userConfig.getSetting("login","rememberMe")
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
            //isEnabled: value
            
            settingText: textSetting
            width: listView.width
            switchButtonMaxSize: 30
            
        }
        
    }
*/
}




