import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

import "../controls"
import "../Utils.js" as Utils

import core.UserSchedules 1.0
import core.UserConfig 1.0
import core.CrnPicker 1.0

Item {
    id: mySchedulesPage

    property color backgroundColor: "#1f3a62"
    property color textColor: "#ffffff"
    property color secondaryColor: "#1f222a"

    property int currentScheduleIndex: 0
    property var notifier: undefined


    Rectangle {
        id: background
        color: "#2c313c"
        anchors.fill: parent
    }


    Rectangle {
        id: schedulesHeader
        width: schedulesHeaderText.implicitWidth + 6 * schedulesHeaderText.anchors.margins
        height: schedulesHeaderText.implicitHeight + 3 * schedulesHeaderText.anchors.margins
        color: mySchedulesPage.secondaryColor
        radius: 25
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.leftMargin: 75

        Text {
            id: schedulesHeaderText
            width: 205
            color: mySchedulesPage.textColor
            text: qsTr("My Schedules")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 5
        }
    }

    Rectangle {
        id: schedules
        color: mySchedulesPage.secondaryColor
        radius: 25
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: schedulesHeader.bottom
        anchors.bottom: parent.bottom
        anchors.rightMargin: 100
        anchors.bottomMargin: 50
        anchors.topMargin: 25
        anchors.leftMargin: 100

        ListView {
            id: schedulesList
            anchors.fill: parent
            anchors.margins: 5
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.bottomMargin: 15
            anchors.topMargin: 15
            clip: true
            spacing: 15
            model: userSchedulesModel

            delegate: Item {

                MouseArea{
                    anchors.fill: parent
                    onClicked: schedulesList.currentIndex = index
                }

                height: column.implicitHeight
                width: schedulesList.width

                Rectangle{
                    anchors.fill: parent
                    radius: 15
                    color: index === schedulesList.currentIndex ? Qt.rgba(schedules.color.r * 1.2, schedules.color.g * 1.2,
                                                                          schedules.color.b * 1.2, schedules.color.a * 1.2)
                                                                : "transparent"
                }


                RowLayout{
                    anchors.fill: parent

                    Column{
                        id: column
                        Layout.fillWidth: true
                        width: 100
                        spacing: 5
                        padding: 5
                        Text{
                            id: name
                            text: scheduleName
                            font.pixelSize: 20
                            wrapMode: Text.WordWrap
                            color: mySchedulesPage.textColor
                            width: column.width
                        }

                        Text{
                            id: listECRN
                            text: "Courses to be picked: " + ECRN.join(', ')
                            font.pixelSize: 15
                            wrapMode: Text.WordWrap
                            color: mySchedulesPage.textColor
                            leftPadding: 15
                            width: column.width
                        }

                        Text{
                            id: listSCRN
                            text: "Courses to be dropped: " + SCRN.join(', ')
                            font.pixelSize: 15
                            wrapMode: Text.WordWrap
                            color: mySchedulesPage.textColor
                            leftPadding: 15
                            width: column.width
                        }
                    }

                    Row{
                        id: scheduleControls
                        spacing: 5
                        visible: index === schedulesList.currentIndex
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.fillHeight: false
                        padding: 5

                        TopBarButton{
                            id: selectSchedule
                            buttonColorClicked: "#00b42b"
                            buttonIconSource: "../../images/svg_images/check_icon.svg"
                            radius: 10
                            width: 50
                            height: 50
                            imageHeight: 24
                            imageWidth: 24

                            onClicked: {
                                if(CrnPicker.isWorking){
                                    Utils.notify(notifier, "Stop post request to change current schedule", "../../images/svg_images/close_icon.svg", "dark red")
                                    return
                                }

                                UserConfig.currentSchedule = scheduleName
                                Utils.notify(notifier, "Changed current schedule","../../images/svg_images/check_icon.svg", "dark green")

                            }
                        }

                        TopBarButton{
                            id: editSchedule
                            buttonIconSource: "../../images/svg_images/calendar_edit_icon.svg"
                            radius: 10
                            width: 50
                            height: 50
                            imageHeight: 24
                            imageWidth: 24

                            onClicked: {

                                if(UserConfig.currentSchedule === scheduleName && CrnPicker.isWorking){
                                    Utils.notify(notifier, "Stop post requests to edit the schedule", "../../images/svg_images/close_icon.svg", "dark red")
                                    return
                                }

                                scheduleEditLoader.scheduleIndex = index
                                scheduleEditLoader.active = true
                            }
                        }

                        TopBarButton{
                            id: deleteSchedule
                            buttonColorClicked: "#ba0000"
                            buttonIconSource: "../../images/svg_images/delete_icon.svg"
                            radius: 10
                            width: 50
                            height: 50
                            imageHeight: 24
                            imageWidth: 24

                            onClicked:{

                                if(UserConfig.currentSchedule === scheduleName && CrnPicker.isWorking){
                                    Utils.notify(notifier, "Stop post requests to delete the schedule", "../../images/svg_images/close_icon.svg", "dark red")
                                    return
                                }

                                if(index === UserSchedules.getIndex(UserConfig.currentSchedule)){
                                    UserConfig.currentSchedule = ""
                                }

                                UserSchedules.deleteSchedule(index)
                                Utils.notify(notifier, "Deleted the schedule","../../images/svg_images/check_icon.svg", "dark green")

                                userSchedulesModel.updateModel()
                                UserConfig.currentScheduleChanged()

                            }
                        }
                    }
                }
            }
        }

        CustomButton {
            id: customButton
            text: "Create a Schedule"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 5
            anchors.bottomMargin: 5

            width: Math.min(150, parent.width/5)
            height: Math.min(100, parent.height/5)

            onClicked: {
                scheduleCreateLoader.active = true
            }

        }
    }

    Loader {
        id: scheduleCreateLoader
        anchors.fill: parent
        source: "../panels/CreateSchedulePanel.qml"
        active: false
    }

    Loader {
        id: scheduleEditLoader
        anchors.fill: parent
        source: "../panels/EditSchedulePanel.qml"
        active: false
        property int scheduleIndex;
    }

    Connections{
        target: scheduleEditLoader.item

        function onSaved(){
            userSchedulesModel.updateModel()
            scheduleEditLoader.active = false
        }

        function onCancelled(){
            scheduleEditLoader.active = false
        }

    }

    Connections{
        target: scheduleCreateLoader.item

        function onSaved(){
            userSchedulesModel.updateModel()
            scheduleCreateLoader.active = false
        }

        function onCancelled(){
            scheduleCreateLoader.active = false
        }

    }

}
