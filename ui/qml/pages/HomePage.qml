import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

import "../panels"
import "../controls"
import "../Utils.js" as Utils

import core.UserConfig 1.0
import core.UserSchedules 1.0
import core.CrnPicker 1.0


Item {
    id: homePage
    property color backgroundColor: "#2c313c"
    property color secondaryColor: "#1f222a"
    property color textColor: "#ffffff"

    property var notifier: undefined

    property int timeElapsedWorking: 0



    Rectangle {
        id: background
        color: backgroundColor
        anchors.fill: parent

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

        notifier: parent.notifier

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

                    Flickable{
                        anchors.fill: parent
                        contentHeight: column.implicitHeight + column.anchors.margins * 2
                        clip: true

                        Column{
                            id: column
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 20

                            Text{
                                text: "CRNs to be picked:"
                                color: textColor
                                font.pixelSize: 25
                            }

                            ListView{
                                model: schedule.currentScheduleECRN
                                height: contentHeight
                                width: column.width
                                spacing: 10
                                interactive: false

                                delegate: Text{
                                    text: (UserConfig.latestResponse[modelData] ? (UserConfig.latestResponse[modelData]["statusCode"] === "0" ? "✔️" : "❌") : "")
                                          + modelData + ": " + (UserConfig.latestResponse[modelData] ? UserConfig.latestResponse[modelData]["message"]
                                                                                                     : "Post request is not sent")
                                    color: textColor
                                    font.pixelSize: 20
                                    wrapMode: Text.WordWrap
                                    width: parent.width
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
                                spacing: 10
                                interactive: false

                                delegate: Text{
                                    text: (UserConfig.latestResponse[modelData] ? (UserConfig.latestResponse[modelData]["statusCode"] === "0" ? "✔️" : "❌") : "")
                                          + modelData + ": " + (UserConfig.latestResponse[modelData] ? UserConfig.latestResponse[modelData]["message"]
                                                                                                     : "Post request is not sent")
                                    color: textColor
                                    font.pixelSize: 20
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }
                            }
                        }
                    }
                }

                Rectangle{
                    id: statisticsLayout
                    Layout.alignment: Qt.AlignRight
                    color: "transparent"
                    Layout.rowSpan: 9
                    Layout.columnSpan: 4
                    Layout.row:0
                    Layout.column: 7

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 18

                    clip: true
                    Rectangle{
                        id: statisticsBackground
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: statistics.height + statistics.anchors.margins * 2

                        color: backgroundColor
                        radius: 15

                        ListView{
                            id: statistics
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            height: Math.min(statisticsLayout.height, contentHeight)
                            anchors.margins: 10
                            spacing: 15
                            clip: true

                            delegate: Text {
                                text: statistic + ": " + prefix + value + postfix
                                color: textColor
                                font.pixelSize: 25
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }


                            model: ListModel{
                                // this is an ugly hack to use binding in ListElements
                                // https://stackoverflow.com/questions/7659442/listelement-fields-as-properties

                                id: statisticsModel

                                property bool completed: false
                                Component.onCompleted: {
                                    append({statistic: "Post Request Made", value: UserConfig.requestCount.toString(),
                                               prefix: "" , postfix: ""});

                                    append({statistic: "Success Rate", value: statistics.calculateSuccessPercantage().toString(),
                                               prefix: "%" , postfix: ""});

                                    append({statistic: "Running Since", value: Utils.secondsToDate(timeElapsedWorking).toString(),
                                               prefix: "" , postfix: ""});

                                    completed = true;
                                }

                            }
                            // Update the list model:

                            // setProperty(index, data, value)
                            // index is the index of the element in the model,
                            // data is the variable in model
                            // value is the new value

                            Connections{
                                target: UserConfig
                                function onRequestCountChanged() {
                                    if(statisticsModel.completed) statisticsModel.setProperty(0, "value", UserConfig.requestCount.toString());
                                }
                            }

                            Connections{
                                target: UserConfig
                                function onLatestResponseChanged(){
                                    if(statisticsModel.completed) statisticsModel.setProperty(1, "value", statistics.calculateSuccessPercantage().toString());
                                }
                            }

                            Connections{
                                target: homePage
                                function onTimeElapsedWorkingChanged(){
                                    if(statisticsModel.completed) statisticsModel.setProperty(2, "value", Utils.secondsToDate(timeElapsedWorking).toString());
                                }
                            }

                            function calculateSuccessPercantage(){
                                var total = 0
                                var success = 0
                                for (const [key, value] of Object.entries(UserConfig.latestResponse)) {
                                    if(value["statusCode"] === "0"){
                                        success += 1
                                    }
                                    total += 1
                                }

                                if(total === 0) return 0

                                return 100 * success / total
                            }

                        }

                    }
                }

                CircularProgressBar {
                    id: requestProgressBar

                    Layout.rowSpan: 2
                    Layout.columnSpan: 2
                    Layout.row: 9
                    Layout.column: 7

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Layout.preferredHeight: 1
                    Layout.preferredWidth: 1

                    currentValue: 0
                    maximumValue: UserConfig.requestInterval
                    minimumValue: 0
                    text: (UserConfig.requestInterval - requestProgressBar.currentValue).toFixed(2) + "s"
                    secondaryColor: "#4891d9"
                    primaryColor: "#ffffff"

                    Timer{
                        id: requestTimer
                        interval: UserConfig.requestInterval * 1000
                        repeat: true
                        running: CrnPicker.isWorking
                        triggeredOnStart: true
                        onTriggered: progressValueAnimation.start()
                    }

                    NumberAnimation{
                        id: progressValueAnimation
                        from: 0
                        to: UserConfig.requestInterval

                        running: CrnPicker.isWorking

                        target: requestProgressBar
                        property: "currentValue"
                        duration: UserConfig.requestInterval * 975 // to prevent conflict between timer and animation

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

                    text: CrnPicker.isWorking ? "Stop Post Requests" : "Start Post Requests"
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredHeight: 1
                    Layout.preferredWidth: 1
                    colorDefault: CrnPicker.isWorking ? "#bd0000" : "#009b23"
                    colorMouseOver: CrnPicker.isWorking ? "#f90000" : "#00d22f"
                    colorPressed: CrnPicker.isWorking ? "#bd0000" : "#009b23"

                    onClicked: {
                        if(UserConfig.currentSchedule === "") return

                        if(CrnPicker.isWorking){
                            CrnPicker.stopRequests()
                        }else{
                            CrnPicker.startRequests()
                        }
                    }
                }
            }
        }
    }

    Timer{
        id: workingTimeCounter
        interval: 1000 // 1 second
        repeat: true
        running: requestScheduler.running
        triggeredOnStart: false

        onTriggered: {
            homePage.timeElapsedWorking += 1
        }
    }

    Timer{
        id: requestScheduler
        interval: UserConfig.requestInterval * 1000
        repeat: true
        running: CrnPicker.isWorking
        triggeredOnStart: true
        onTriggered: {
            CrnPicker.sendRequest()
        }

    }

    Timer{
        id: tokenRefresh
        interval: UserConfig.tokenRefreshInterval * 1000
        repeat: true
        running: loginPanel.isLoggedIn
        triggeredOnStart: false

        onTriggered: {
            loginPanel.refreshAuthToken()
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


}
