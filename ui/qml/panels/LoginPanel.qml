import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

import "../controls"
import "../../../core/ItuLogin"

Rectangle {
    id: login
    width: 250
    height: 400
    color: "#1f222a"
    radius: 10
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    property bool isLoggedIn: false
    property real compactModeWidth: 250
    property real compactModeHeight: 100

    onWidthChanged: console.log(width)

    /*
    property bool isLoggedIn: logger.isLoggedIn()

        ItuLogin{
        id: logger

        Component.onCompleted: console.log(logger.isLoggedIn())
    }
*/

    MouseArea{
        id: logoutMouseArea
        anchors.fill: parent
        visible: false
        opacity: 0
        onClicked: isLoggedIn = false // will open a box to confirm logout or show user info too
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
                    focus: false
                    Layout.minimumHeight: 7
                    Layout.preferredHeight: 3
                    Layout.maximumHeight: 30
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: false
                    buttonColorDefault: "#2c313c"

                    settingText: "Remember Me"

                }



                CustomButton{
                    id: buttonLogin
                    text: qsTr("Login")
                    Layout.minimumHeight: 15
                    Layout.preferredWidth: 1
                    Layout.bottomMargin: 10
                    Layout.rightMargin: 10
                    Layout.leftMargin: 10
                    Layout.preferredHeight: 2
                    Layout.rowSpan: 1
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.maximumHeight: 150
                    Layout.maximumWidth: 350
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    onClicked: isLoggedIn = true

                }
            }
        }
    }

    states: [
        State {
            name: "Compact Logged In"
            when: login.isLoggedIn

            AnchorChanges {
                target: login
                anchors.verticalCenter: undefined
                anchors.horizontalCenter: undefined
                anchors.top: parent.top
                anchors.right: parent.right
            }

            PropertyChanges {
                target: login

                height: compactModeHeight
                width: compactModeWidth

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
                anchors.horizontalCenterOffset: (-1* compactModeWidth/2) + image.width / 2
            }

            PropertyChanges {
                target: loginCompactInfo
                visible: true
                text: qsTr("Logged in as USERNAME ")
                font.pixelSize: 15
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: ""; to: "Compact Logged In"; reversible: false
            ParallelAnimation {
                NumberAnimation { target: login; properties: "height"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { target: login; properties: "width"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "opacity"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "visible"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "anchors.horizontalCenterOffset"; duration: 500; easing.type: Easing.InOutQuad }
                AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            from: "Compact Logged In"; to: ""; reversible: false
            ParallelAnimation {
                NumberAnimation { target: login; properties: "height"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { target: login; properties: "width"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "opacity"; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "visible"; duration: 10; easing.type: Easing.InOutQuad }
                NumberAnimation { properties: "anchors.horizontalCenterOffset"; duration: 500; easing.type: Easing.InOutQuad }
                AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }
        }

    ]
}
