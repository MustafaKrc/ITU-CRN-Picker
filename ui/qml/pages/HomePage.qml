import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts


//import "../../../core/ItuLogin" 1.0
//import core.ItuLogin 1.0
import "../panels"
import "../controls"

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
                columns: 4
                rows: 4

                Column{

                    Layout.rowSpan: 3
                    Layout.columnSpan: 3
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
                        font.pixelSize: 25
                    }

                    Text {
                        id: scheduleECRN
                        text: "CRNs to be picked: " + schedule.currentScheduleECRN
                        color: textColor
                        width: parent.width

                        wrapMode: Text.WordWrap
                        //fontSizeMode: Text.Fit
                        font.pixelSize: 25
                    }

                    Text {
                        id: scheduleSCRN
                        text: "CRNs to be dropped: " + schedule.currentScheduleSCRN
                        color: textColor
                        width: parent.width

                        wrapMode: Text.WordWrap
                        //fontSizeMode: Text.Fit
                        font.pixelSize: 25
                    }
                }


                Rectangle{
                    id: crnStatusBackground
                    Layout.alignment: Qt.AlignRight
                    color: backgroundColor
                    Layout.rowSpan: 2
                    Layout.columnSpan: 2
                    Layout.row:0
                    Layout.column: 3
                    Layout.minimumHeight: 50
                    Layout.minimumWidth: 25

                    Layout.preferredHeight: column.implicitHeight + column.anchors.margins * 2
                    Layout.preferredWidth: column.implicitWidth + column.anchors.margins * 2

                    //Layout.maximumHeight: 200
                    //Layout.maximumWidth: 100

                    radius: 15

                    ColumnLayout{
                        id: column
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Text{
                            text: "CRNs to be picked:"
                            color: textColor
                            font.pixelSize: 20
                            Layout.fillWidth: true
                        }

                        ListView{
                            model: schedule.currentScheduleECRN
                            height: contentHeight
                            Layout.fillWidth: true

                            delegate: Text{
                                text: modelData + ": " + (UserConfig.latestResponse[modelData] ? UserConfig.latestResponse[modelData]
                                                                                              : "Post request is not made")
                                color: textColor
                                font.pixelSize: 15
                            }
                        }

                        Text{
                            text: "CRNs to be dropped:"
                            color: textColor
                            font.pixelSize: 20
                            Layout.fillWidth: true
                        }

                        ListView{
                            model: schedule.currentScheduleSCRN
                            height: contentHeight
                            width: implicitWidth
                            Layout.fillWidth: true

                            delegate: Text{
                                text: modelData + ": " + (UserConfig.latestResponse[modelData] ? UserConfig.latestResponse[modelData]
                                                                                              : "Post request is not made")
                                color: textColor
                                font.pixelSize: 15
                            }
                        }
                    }
                }

                CustomButton{
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredHeight: 75
                    Layout.preferredWidth: 150

                    Layout.rowSpan: 1
                    Layout.columnSpan: 1
                    Layout.row: 3
                    Layout.column: 2
                }

                CustomButton{
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredHeight: 75
                    Layout.preferredWidth: 150

                    Layout.rowSpan: 1
                    Layout.columnSpan: 1
                    Layout.row: 3
                    Layout.column: 3
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
