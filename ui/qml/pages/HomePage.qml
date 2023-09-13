import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts


import "../panels"
import "../controls"

//import core.ItuLogin 1.0
import core.UserConfig 1.0
import core.UserSchedules 1.0
import core.CrnPicker 1.0

Item {
    id: homePage
    property color backgroundColor: "#2c313c"
    property color secondaryColor: "#1f222a"
    property color textColor: "#ffffff"


    Rectangle {
        id: background
        color: backgroundColor
        anchors.fill: parent

    }

    CrnPicker{
        id: crnPicker
    }

    LoginPanel{
        id: loginPanel
        width: parent.width/3
        height: 3*parent.height/4
        visible: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        compactModeBigWidth: 250
        compactModeBigHeight: 100

        compactModeSmallWidth: 75
        compactModeSmallHeight: 75
        //compactMode: LoginPanel.CompactMode.SmallTopRight
    }

    Item{
        anchors.fill: parent
        id: app
        opacity: 0
        visible: false



        Rectangle {
            id: scheduleHeader
            width: scheduleHeaderText.implicitWidth + 6 * scheduleHeaderText.anchors.margins
            height: scheduleHeaderText.implicitHeight + 3 * scheduleHeaderText.anchors.margins
            color: secondaryColor
            radius: 22
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.leftMargin: 75

            Text {
                id: scheduleHeaderText
                width: 205
                color: textColor
                text: qsTr("Current Schedule")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                font.pixelSize: 35
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 5
            }
        }


        Rectangle {
            id: schedule
            color: secondaryColor
            radius: 25
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: scheduleHeader.bottom
            anchors.bottom: parent.bottom
            anchors.rightMargin: 100
            anchors.bottomMargin: 50
            anchors.topMargin: 25
            anchors.leftMargin: 100

            property string currentScheduleName: UserConfig.currentSchedule
            property int currentScheduleIndex: UserConfig.currentSchedule !== "" ? UserSchedules.getIndex(UserConfig.currentSchedule) : -1
            property var currentScheduleECRN: currentScheduleIndex !== -1 ? UserSchedules.getECRNList(currentScheduleIndex) : []
            property var currentScheduleSCRN: currentScheduleIndex !== -1 ? UserSchedules.getSCRNList(currentScheduleIndex) : []

            GridLayout{
                anchors.fill: parent
                anchors.margins: 15
                rowSpacing: 10
                columns: 10
                rows: 10

                ColumnLayout{
                    id: information
                    Layout.fillHeight: true
                    Layout.preferredWidth: 5
                    Layout.preferredHeight: 1

                    Layout.rowSpan: 5
                    Layout.columnSpan: 6
                    Layout.row: 0
                    Layout.column: 0
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 10
                    clip: true

                    Text {
                        id: scheduleName
                        text: schedule.currentScheduleName
                        color: textColor
                        width: parent.width
                        font.bold: true

                        wrapMode: Text.WordWrap
                        //fontSizeMode: Text.Fit
                        font.pixelSize: 35
                    }
                }


                Rectangle{
                    id: crnStatusBackground
                    Layout.alignment: Qt.AlignRight
                    color: "transparent" //backgroundColor
                    Layout.rowSpan: 6
                    Layout.columnSpan: 6
                    Layout.row:5
                    Layout.column: 0

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    radius: 15
                    Layout.preferredWidth: 5
                    Layout.preferredHeight: 1
                    clip: true

                    Column{
                        id: column
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Text{
                            text: "CRNs to be picked:"
                            color: textColor
                            font.pixelSize: 25
                        }

                        ListView{
                            model: schedule.currentScheduleECRN
                            height: contentHeight
                            width: column.width

                            delegate: Text{
                                text: modelData + ": " + (UserConfig.latestResponse[modelData] ? UserConfig.latestResponse[modelData]
                                                                                               : "Post request is not sent")
                                color: textColor
                                font.pixelSize: 20
                            }
                        }

                        Text{
                            text: "CRNs to be dropped:"
                            color: textColor
                            font.pixelSize: 25
                        }

                        ListView{
                            model: schedule.currentScheduleSCRN
                            height: contentHeight
                            width: column.width

                            delegate: Text{
                                text: modelData + ": " + (UserConfig.latestResponse[modelData] ? UserConfig.latestResponse[modelData]
                                                                                               : "Post request is not sent")
                                color: textColor
                                font.pixelSize: 20
                            }
                        }
                    }
                }


                Rectangle{
                    id: statisticsBackground
                    Layout.alignment: Qt.AlignRight
                    color: backgroundColor
                    Layout.rowSpan: 9
                    Layout.columnSpan: 4
                    Layout.row:0
                    Layout.column: 7

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    radius: 15
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 18

                    clip: true

                    ListView{
                        id: statistics
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 15

                        delegate: Text {
                            text: statistic + ": " + prefix + value + postfix
                            color: textColor
                            font.pixelSize: 25
                        }

                        model: ListModel{
                            ListElement {
                                statistic: "Post Request Made"
                                value: 555
                                prefix: ""
                                postfix: ""
                            }
                            ListElement {
                                statistic: "Success Rate"
                                value: 87
                                prefix: "%"
                                postfix: ""
                            }
                            ListElement {
                                statistic: "Running Since"
                                value: 55
                                prefix: ""
                                postfix: " minutes"
                            }

                        }
                    }
                }

                CustomButton{
                    //Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    //Layout.maximumHeight: 75
                    //Layout.maximumWidth: 300

                    Layout.rowSpan: 2
                    Layout.columnSpan: 2
                    Layout.row: 9
                    Layout.column: 9

                    Component.onCompleted: console.log(crnPicker.isWorking)

                    text: crnPicker.isWorking ? "Stop Post Requests" : "Start Post Requests"
                    highlighted: false
                    flat: false
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredHeight: 1
                    Layout.preferredWidth: 1
                    //colorDefault:

                    onClicked: crnPicker.startRequests()
                }
            }
        }
    }


    states: [
        State {
            name: "Logged In"
            when: loginPanel.isLoggedIn

            PropertyChanges {
                target: loginPanel
                radius: 0
            }

            PropertyChanges {
                target: app
                opacity: 1
                visible: true
            }


        }
    ]

    transitions: [
        Transition {
            from: ""; to: "Logged In"; reversible: true
            ParallelAnimation {
                NumberAnimation { properties: "radius"; duration: 500; easing.type: Easing.InOutQuad}
                NumberAnimation { properties: "opacity"; duration: 500; easing.type: Easing.InOutQuad}
                NumberAnimation { properties: "visible"; duration: 500; easing.type: Easing.InOutQuad}
            }
        }
    ]

    /*
    ItuLogin{
                id: logger

                Component.onCompleted: console.log(logger.isLoggedIn())
            }
    */

    /*
    Loader{
        id: loaderLogin
        asynchronous: true

        sourceComponent: ItuLogin{
            id: logger

            Component.onCompleted: console.log(logger.isLoggedIn())
        }

    }



    Text {
        id: name
        text: "logger.isLoggedIn()"
    }
*/

}
