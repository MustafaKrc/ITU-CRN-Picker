import QtQuick 2.15
import QtQuick.Layouts

import "../controls"
import "../Utils.js" as Utils

import core.UserSchedules 1.0

Item {

    id: root

    signal saved()
    signal cancelled()

    property color shadowColor: "#cd111219"
    property color panelColor: "#1f222a"
    property color textColor: "#ffffff"
    property color panelSecondaryColor: "#2c313c"

    property color inputSelectionColor: "#64769e"


    //property int scheduleIndex // schedule index is provided by the loader

    Rectangle {
        id: shadow
        color: shadowColor
        anchors.fill: parent
        MouseArea{
            id: backgroundMouseCanceller
            anchors.fill: parent
        }

        Rectangle {
            id: editSchedulePanel
            color: panelColor
            radius: 25
            clip: true
            anchors.centerIn: parent
            width: Math.max(parent.width - 400, 400)
            height: Math.max(parent.height - 400, 400)



            ColumnLayout {
                id: schedule
                anchors.fill: parent
                anchors.rightMargin: 50
                anchors.leftMargin: 50
                anchors.bottomMargin: 25
                anchors.topMargin: 25



                SettingInputBox{
                    id: nameSetting
                    spacing: 15
                    settingText: "Schedule Name:"
                    inputColorDefault: panelSecondaryColor
                    height: 400
                    inputToDescWidthRatio: 4
                    inputSelectionColor: inputSelectionColor
                    Layout.preferredHeight: 75
                    Layout.fillWidth: true
                    maximumTextSize: 40
                    order: SettingInputBox.Order.DescriptionFirst
                    value: UserSchedules.getName(scheduleIndex)
                    binderFunction: function(){}
                }

                SettingInputBox{
                    id: ecrnSetting
                    spacing: 15
                    settingText: "Course CRNs to be Picked:"
                    inputColorDefault: panelSecondaryColor
                    inputTextMaxSize: 20
                    inputSelectionColor: inputSelectionColor
                    height: 400
                    inputToDescWidthRatio: 1.5
                    Layout.preferredHeight: 75
                    Layout.fillWidth: true
                    maximumTextSize: 40
                    order: SettingInputBox.Order.DescriptionFirst
                    value: UserSchedules.getECRNList(scheduleIndex).toString()
                    binderFunction: function(){}
                }

                SettingInputBox{
                    id: scrnSetting
                    spacing: 15
                    settingText: "Course CRNs to be dropped:"
                    inputColorDefault: panelSecondaryColor
                    inputTextMaxSize: 20
                    inputSelectionColor: inputSelectionColor
                    height: 400
                    inputToDescWidthRatio: 1.5
                    Layout.preferredHeight: 75
                    Layout.fillWidth: true
                    maximumTextSize: 40
                    order: SettingInputBox.Order.DescriptionFirst
                    value: UserSchedules.getSCRNList(scheduleIndex).toString()
                    binderFunction: function(){}
                }


                RowLayout {
                    id: buttons
                    width: 100
                    height: 100
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true
                    spacing: 15

                    CustomButton {
                        id: save
                        text: "Save"
                        colorPressed: "#009b23"
                        colorMouseOver: "#00d22f"
                        colorDefault: "#009b23"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 70
                        Layout.preferredWidth: 100
                        Layout.fillWidth: false
                        Layout.fillHeight: false

                        onClicked:{
                            var result = UserSchedules.editSchedule(scheduleIndex,nameSetting.value.trim(),
                                                                    ecrnSetting.value.split(",").filter(o=>o).map(item=>item.trim()),
                                                                    scrnSetting.value.split(",").filter(o=>o).map(item=>item.trim()))
                            var returnCode = result[0]
                            var returnMessage = result[1]

                            if(returnCode){
                                Utils.notify(notifier, returnMessage,"../../images/svg_images/check_icon.svg", "dark green")
                            } else {
                                Utils.notify(notifier, returnMessage,"../../images/svg_images/close_icon.svg", "dark red")
                            }


                            root.saved()
                        }

                    }

                    CustomButton {
                        id: cancel
                        text: "Cancel"
                        colorMouseOver: "#f90000"
                        colorPressed: "#bd0000"
                        colorDefault: "#bd0000"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 70
                        Layout.preferredWidth: 100

                        onClicked: root.cancelled()

                    }
                }
            }

            Text {
                id: crnInfo
                y: 376
                text: qsTr("Seperate CRNs with a comma (,)")
                anchors.left: parent.left
                anchors.leftMargin: parent.radius
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.radius
                font.pixelSize: 12
                color: textColor
            }
        }
    }
}
