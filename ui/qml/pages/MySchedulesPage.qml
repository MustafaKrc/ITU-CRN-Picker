import QtQuick 2.15
import QtQuick.Controls

Item {
    id: mySchedulesPage

    property color backgroundColor: "#1f3a62"
    property color textColor: "#ffffff"
    property color secondaryColor: "#1f222a"

    property int currentScheduleIndex: 0


    Rectangle {
        id: rectangle
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

            delegate: Item {

                height: column.implicitHeight
                width: parent.width

                Rectangle{
                    anchors.fill: parent
                    radius: 15
                    color: index === schedulesList.currentIndex ? Qt.rgba(schedules.color.r * 1.2, schedules.color.g * 1.2,
                                                                          schedules.color.b * 1.2, schedules.color.a * 1.2)
                                                                : "transparent"
                }

                Column{
                    id: column
                    spacing: 5
                    padding: 5
                    Text{
                        id: name
                        text: scheduleName
                        font.pixelSize: 20
                        color: mySchedulesPage.textColor

                    }

                    Text{
                        id: listECRN
                        text: "Courses to be picked: " + ECRN.join(', ')
                        font.pixelSize: 15
                        color: mySchedulesPage.textColor
                        leftPadding: 15
                    }

                    Text{
                        id: listSCRN
                        text: "Courses to be dropped: " + SCRN.join(', ')
                        font.pixelSize: 15
                        color: mySchedulesPage.textColor
                        leftPadding: 15
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: schedulesList.currentIndex = index
                }

            }


            model: userSchedulesModel
        }
    }

}
