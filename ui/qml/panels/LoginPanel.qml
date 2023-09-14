import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material


import "../controls"
import "../Utils.js" as Utils

import core.ItuLogin 1.0
import core.UserConfig 1.0

import ".."

Rectangle {
    id: login
    width: 250
    height: 400
    color: "#1f222a"
    radius: 10
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    property bool isLoggedIn: false
    property real compactModeBigWidth: 250
    property real compactModeBigHeight: 100
    property real compactModeSmallWidth: 75
    property real compactModeSmallHeight: 75
    property int compactMode: LoginPanel.CompactMode.BigTopRight

    property var notifier: undefined



    enum CompactMode{
        BigTopRight,
        SmallTopRight
    }

    ItuLogin{
        id: ituLogin

        Component.onCompleted: {var a = 0;} // this makes sure onDestruction gets called.
                                            // if app gets closed wtihout doing anything, onDestruction wouldnt emit..

        Component.onDestruction: {
            ituLogin.close()
        }

    }


    MouseArea{
        id: logoutMouseArea
        anchors.fill: parent
        visible: false
        opacity: 0
        onClicked: {

            /*
              will open a panel to show user info etc..

              */

            var result = ituLogin.logout()
            var returnCode = result[0]
            var returnMessage = result[1]

            if(returnCode){
                isLoggedIn = false
                Utils.notify(notifier, returnMessage,"../../images/svg_images/check_icon.svg", "dark green")
            } else{
                isLoggedIn = true
                Utils.notify(notifier, returnMessage,"../../images/svg_images/close_icon.svg", "dark red")
            }

        }
        // add hover cursor change
    }

    ColumnLayout {
        id: loginLayout
        anchors.fill: parent
        layoutDirection: Qt.LeftToRight

        Rectangle {
            id: profilePhoto
            width: 200
            height: 200
            color: "#00581383"
            Layout.preferredHeight: 4
            Layout.columnSpan: 1
            Layout.fillHeight: true
            Layout.rowSpan: 1
            Layout.preferredWidth: -1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            Image {
                id: image
                width: 100
                height: 108
                anchors.verticalCenter: parent.verticalCenter
                source: "../../images/svg_images/guest_icon.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.height: 170
                sourceSize.width: 170
                fillMode: Image.PreserveAspectFit
            }

            Text {
                id: loginCompactInfo
                visible: false
                opacity: 0
                color: "#ffffff"
                text: qsTr("Logged in as USERNAME")
                anchors.verticalCenter: image.verticalCenter
                anchors.left: image.right
                anchors.right: parent.right
                font.pixelSize: 15
                wrapMode: Text.WordWrap
            }
        }

        Rectangle {
            id: userCredentials
            width: 200
            height: 200
            color: "#005c6131"
            Layout.preferredHeight: 4
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                id: userCredentialsLayout
                anchors.fill: parent
                anchors.bottomMargin: 15
                anchors.topMargin: 15
                spacing: 15

                TextField {
                    id: username
                    selectionColor: "#4891d9"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    placeholderText: qsTr("Username")
                    background: Rectangle{
                        color: "#2c313c"
                        radius: 15

                    }
                    width: implicitWidth
                    color: "#ddffffff"
                    placeholderTextColor: "#4891d9"
                    Layout.rightMargin: 15
                    Layout.leftMargin: 15
                    Layout.maximumHeight: 75
                    Layout.maximumWidth: 350
                    font.pixelSize: Math.max(10,height/4)

                    cursorDelegate: Rectangle {
                        id: cursorUsername
                        visible: username.cursorVisible
                        color: "#4891d9"
                        width: password.cursorRectangle.width*2
                        height: password.cursorRectangle.height*0.75
                        SequentialAnimation {
                            loops: Animation.Infinite
                            running: username.cursorVisible

                            PropertyAction {
                                target: cursorUsername
                                property: 'visible'
                                value: true
                            }

                            PauseAnimation {
                                duration: 600
                            }

                            PropertyAction {
                                target: cursorUsername
                                property: 'visible'
                                value: false
                            }

                            PauseAnimation {
                                duration: 600
                            }

                            onStopped: {
                                cursorUsername.visible = false
                            }
                        }
                    }
                }

                TextField {
                    id: password
                    selectionColor: "#4891d9"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    placeholderText: qsTr("Password")
                    background: Rectangle{
                        color: "#2c313c"
                        radius: 15

                    }
                    font.pixelSize: Math.max(10,height/4)
                    width: implicitWidth
                    color: "#ddffffff"
                    passwordMaskDelay: 500
                    placeholderTextColor: "#4891d9"
                    Layout.rightMargin: 15
                    Layout.leftMargin: 15
                    Layout.maximumHeight: 75
                    Layout.maximumWidth: 350
                    echoMode: TextInput.Password


                    cursorDelegate: Rectangle {
                        id: cursorPassword
                        visible: password.cursorVisible
                        color: "#4891d9"
                        width: password.cursorRectangle.width*2
                        height: password.cursorRectangle.height*0.75
                        SequentialAnimation {
                            loops: Animation.Infinite
                            running: password.cursorVisible

                            PropertyAction {
                                target: cursorPassword
                                property: 'visible'
                                value: true
                            }

                            PauseAnimation {
                                duration: 600
                            }

                            PropertyAction {
                                target: cursorPassword
                                property: 'visible'
                                value: false
                            }

                            PauseAnimation {
                                duration: 600
                            }

                            onStopped: {
                                cursorPassword.visible = false
                            }
                        }
                    }
                }





            }
        }

        Rectangle {
            id: buttons
            width: 200
            height: 200
            color: "#007c7b79"
            Layout.preferredHeight: 3
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                id: buttonLayout
                anchors.fill: parent
                spacing: 25


                SettingSwitchButton{
                    id: buttonRememberMe
                    buttonColorMouseOver: "#1c1d20"
                    buttonColorDefault: "#36373c"
                    Layout.preferredHeight: 1
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.maximumHeight: 50
                    Layout.minimumHeight: 12
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    alignMode: SettingSwitchButton.Align.HorizontalCenter
                    settingText: "Remember Me"
                    switchButtonMaxSize : 40
                    minimumTextSize: 10

                    value: UserConfig.rememberMe
                    binderFunction: function(parent){UserConfig.rememberMe = !UserConfig.rememberMe;}
                }


                CustomButton{
                    id: buttonLogin
                    text: qsTr("Login")
                    Layout.preferredHeight: 1
                    Layout.minimumHeight: 35
                    Layout.bottomMargin: 10
                    Layout.rightMargin: 10
                    Layout.leftMargin: 10
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.maximumHeight: 150
                    Layout.maximumWidth: 350
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    onClicked: {
                        //isLoggedIn = true

                        busyPopup.open()
                        busyIndicatorTimer.start()


                    }
                }
            }
        }
    }



    // workaround to not use threads in python
    // WorkerScript does not work, because we cannot pass ituLogin component
    Timer {
        id: busyIndicatorTimer
        interval: 50
        onTriggered: {
            var result = ituLogin.login(username.text,password.text)
            var returnCode = result[0]
            var returnMessage = result[1]


            if(returnCode){
                isLoggedIn = true
                Utils.notify(notifier, returnMessage,"../../images/svg_images/check_icon.svg", "dark green")
            } else{
                isLoggedIn = false
                Utils.notify(notifier, returnMessage,"../../images/svg_images/close_icon.svg", "dark red")
            }

            busyPopup.close()

        }
    }

    Popup {
        id: busyPopup
        anchors.centerIn: parent
        closePolicy: Popup.NoAutoClose
        modal: true


        onAboutToShow: {
            busyIndicator.running = true;
            busyIndicator.visible = true;
        }

        onAboutToHide: {
            busyIndicator.running = false;
            busyIndicator.visible = false;
        }

        BusyIndicator {
            id: busyIndicator
            anchors.fill: parent
            running: false
            visible: false

            Material.accent: "#55AAFF"

        }

        background: Rectangle {
            color: "#cd111219"
        }

    }



    Image {
        id: imageTopRight
        width: 50
        height: 50
        visible: false
        opacity: 0
        source: "../../images/svg_images/guest_icon.svg"
        sourceSize.height: 170
        sourceSize.width: 170
        fillMode: Image.PreserveAspectFit

        x: login.parent.width - width - 10
        y: 10

        MouseArea{
            anchors.fill: parent
            onClicked: login.isLoggedIn = false
        }

    }

    states: [
        State {
            name: "Compact Small Top Right"
            when: login.isLoggedIn && login.compactMode === LoginPanel.CompactMode.BigTopRight
            AnchorChanges {
                target: login
                anchors.verticalCenter: undefined
                anchors.horizontalCenter: undefined
                anchors.top: parent.top
                anchors.right: parent.right
            }

            PropertyChanges {
                target: login

                height: compactModeBigHeight
                width: compactModeBigWidth

            }

            PropertyChanges {
                target: logoutMouseArea
                visible: true
            }

            PropertyChanges {
                target: userCredentials
                visible: false
                opacity: 0
            }

            PropertyChanges {
                target: buttons
                visible: false
                opacity: 0
            }

            PropertyChanges {
                target: image
                anchors.horizontalCenterOffset: ( -1 * compactModeBigWidth / 2) + image.width / 2
            }

            PropertyChanges {
                target: loginCompactInfo
                visible: true
                text: qsTr("Logged in as USERNAME ")
                font.pixelSize: 15
                opacity: 1
            }
        },
        State {
            name: "Compact Small Top Right Image"
            when: login.isLoggedIn && login.compactMode === LoginPanel.CompactMode.SmallTopRight


            AnchorChanges {
                target: login
                anchors.verticalCenter: undefined
                anchors.horizontalCenter: undefined
                anchors.top: parent.top
                anchors.right: parent.right
            }

            PropertyChanges {
                target: login

                height: compactModeSmallWidth
                width: compactModeSmallWidth

            }

            PropertyChanges {
                target: logoutMouseArea
                visible: true
            }

            PropertyChanges {
                target: userCredentials
                visible: false
                opacity: 0
            }

            PropertyChanges {
                target: buttons
                visible: false
                opacity: 0
            }

            PropertyChanges {
                target: image
                height: compactModeSmallWidth
                width: compactModeSmallWidth
            }


        }
    ]

    transitions: [
        Transition {
            from: ""; to: "Compact Small Top Right"; reversible: false
            ParallelAnimation {
                NumberAnimation { target: login; properties: "height"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { target: login; properties: "width"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "opacity"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "visible"; duration: 750; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "anchors.horizontalCenterOffset"; duration: 500; easing.type: Easing.InOutQuad }
                AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            from: "Compact Small Top Right"; to: ""; reversible: false
            ParallelAnimation {
                NumberAnimation { target: login; properties: "height"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { target: login; properties: "width"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "opacity"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "visible"; duration: 10; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "anchors.horizontalCenterOffset"; duration: 500; easing.type: Easing.InOutQuad }
                AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            from: ""; to: "Compact Small Top Right Image"; reversible: false
            ParallelAnimation {
                NumberAnimation { properties: "height"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "width"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "opacity"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "visible"; duration: 750; easing.type: Easing.InOutQuad }
                AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad }

            }
        },
        Transition {
            from: "Compact Small Top Right Image"; to: ""; reversible: false
            ParallelAnimation {
                NumberAnimation { properties: "height"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "width"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "opacity"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "visible"; duration: 10; easing.type: Easing.InOutQuad }
                AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad }

            }
        }

    ]
}
