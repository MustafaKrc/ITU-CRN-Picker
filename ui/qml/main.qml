import QtQuick
import QtQuick.Window
import QtQuick.Controls 6.3
import QtQuick.Layouts 6.3
import Qt5Compat.GraphicalEffects

import "./controls"
import "./pages"
// dont need to import qml files in same directory
import core.UserConfig 1.0
import core.InternetChecker 1.0
import "./Utils.js" as Utils

Window {
    id: mainWindow
    width: 640
    height: 480
    minimumWidth: 640
    minimumHeight: 480

    // remove title bar
    flags: Qt.Window | Qt.FramelessWindowHint

    visible: true
    color: "#002a2a2a"
    title: qsTr("ITU Crn Picker")

    // properties

    property int windowStatus: Enums.WindowStatus.Normal
    property int windowMargin : {
        if(windowStatus === Enums.WindowStatus.Normal){
            3
        } else if(Enums.WindowStatus.Maximized){
            0
        }
    }
    property var activeMenuButton: buttonHome

    QtObject{
        id: internal

        function maximizeRestore(){
            if(windowStatus === Enums.WindowStatus.Normal){
                mainWindow.showMaximized()
                windowStatus = Enums.WindowStatus.Maximized
            }
            else if(windowStatus === Enums.WindowStatus.Maximized){

                mainWindow.showNormal()
                windowStatus = Enums.WindowStatus.Normal
            }

        }

        function ifMaximizedWindowRestore(){
            if(windowStatus === Enums.WindowStatus.Normal){
                mainWindow.showNormal()
                //windowStatus = Enums.WindowStatus.Maximized
            }
            else if(windowStatus === Enums.WindowStatus.Maximized){
                //mainWindow.showNormal()
                windowStatus = Enums.WindowStatus.Normal
            }
        }

        function restoreMargins(){
            windowStatus = Enums.WindowStatus.Normal
        }

    }


    Rectangle {
        id: background
        color: "#2c313b"
        border.color: "#373e4b"
        border.width: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: windowMargin
        anchors.leftMargin: windowMargin
        anchors.bottomMargin: windowMargin
        anchors.topMargin: windowMargin
        z: 1

        Rectangle {
            id: appContainer
            color: "#00ffffff"
            anchors.fill: parent
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            anchors.topMargin: 1

            Rectangle {
                id: topBar
                height: 60
                color: "#1c1d20"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                ToggleButton{
                    onClicked: animationMenu.running =  true
                }

                Rectangle {
                    id: topBarDescription
                    y: 37
                    height: 25
                    color: "#252931"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.leftMargin: 70
                    anchors.bottomMargin: 0

                    Label {
                        id: labelTopInfo
                        color: "#a4a4a4"
                        text: qsTr("App description")
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 8
                        anchors.rightMargin: 300
                        anchors.leftMargin: 10
                    }

                    Label {
                        id: labelRightInfo
                        x: -60
                        y: -35
                        color: "#a4a4a4"
                        text: qsTr("| HOME")
                        anchors.left: labelTopInfo.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 8
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                        anchors.leftMargin: 0
                        anchors.rightMargin: 10
                    }
                }

                Rectangle {
                    id: titleBar
                    height: 35
                    color: "#00ffffff"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 105
                    anchors.leftMargin: 70
                    anchors.topMargin: 0

                    DragHandler{
                        onActiveChanged: if(active){
                                             mainWindow.startSystemMove()
                                             internal.ifMaximizedWindowRestore()
                                         }
                    }

                    Image {
                        id: iconApp
                        width: 22
                        height: 22
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "../images/svg_images/app_logo.png"
                        anchors.leftMargin: 5
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        id: label
                        color: "#ffffff"
                        text: qsTr("ITU CRN Picker")
                        anchors.left: iconApp.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        anchors.rightMargin: 350
                        anchors.leftMargin: 10
                        font.pointSize: 10
                    }
                }

                Row {
                    id: rowButtons
                    anchors.left: titleBar.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: topBarDescription.top

                    TopBarButton{
                        id: buttonMinimize
                        onClicked: {
                            mainWindow.showMinimized()
                            internal.restoreMargins()
                        }

                    }

                    TopBarButton {
                        id: buttonMaximizeRestore
                        buttonIconSource: {
                            if(windowStatus === Enums.WindowStatus.Normal){
                                "../../images/svg_images/maximize_icon.svg"
                            }
                            else if (windowStatus === Enums.WindowStatus.Maximized){
                                "../../images/svg_images/restore_icon.svg"
                            }
                        }

                        onClicked: internal.maximizeRestore()
                    }

                    TopBarButton {
                        id: buttonClose
                        buttonColorClicked: "#d30000"
                        buttonIconSource: "../../images/svg_images/close_icon.svg"
                        onClicked: mainWindow.close()
                    }
                }
            }

            Rectangle {
                id: content
                color: "#00ffffff"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: topBar.bottom
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.bottomMargin: 1
                anchors.leftMargin: 0
                anchors.topMargin: -1

                Rectangle {
                    id: leftMenu
                    width: 70
                    color: "#1c1d20"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    clip: true
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0

                    PropertyAnimation{
                        id: animationMenu
                        target: leftMenu
                        property: "width"
                        to: leftMenu.width === 70 ? 250 : 70
                        duration: 500
                        easing.type: Easing.InOutQuint
                    }

                    Column {
                        id: columnMenus
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: buttonSettings.top

                        LeftMenuButton {
                            id: buttonHome
                            width: leftMenu.width
                            text: qsTr("Home")

                            onClicked: {
                                if(buttonHome.isActiveMenu) return

                                activeMenuButton.isActiveMenu = false
                                buttonHome.isActiveMenu = true
                                activeMenuButton = buttonHome

                                stackView.replace(stackView.get(0),pageHome)
                            }
                        }

                        LeftMenuButton {
                            id: buttonMySchedules
                            width: leftMenu.width
                            text: qsTr("My Schedules")
                            buttonIconSource: "../../images/svg_images/calendar_icon.svg"
                            isActiveMenu: false

                            onClicked: {
                                if(buttonMySchedules.isActiveMenu) return

                                activeMenuButton.isActiveMenu = false
                                buttonMySchedules.isActiveMenu = true
                                activeMenuButton = buttonMySchedules

                                stackView.replace(stackView.get(0),pageMySchedules)
                            }
                        }
                    }

                    LeftMenuButton {
                        id: buttonSettings
                        x: 0
                        y: 223
                        width: leftMenu.width
                        text: qsTr("Settings")
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 25
                        buttonIconSource: "../../images/svg_images/settings_icon.svg"
                        isActiveMenu: false
                        onClicked: {
                            if(buttonSettings.isActiveMenu) return

                            activeMenuButton.isActiveMenu = false
                            buttonSettings.isActiveMenu = true
                            activeMenuButton = buttonSettings

                            stackView.replace(stackView.get(0),pageSettings)
                        }
                    }

                    Label {
                        id: label1
                        color: "#ffffff"
                        text: qsTr("Version ") + UserConfig.version
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: buttonSettings.bottom
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignHCenter
                        anchors.topMargin: 5
                        font.pointSize: 7
                    }
                }

                Rectangle {
                    id: contentPages
                    color: "#00ffffff"
                    anchors.left: leftMenu.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 25
                    anchors.leftMargin: 0
                    anchors.topMargin: 0

                    Component.onCompleted: InternetConnectionChecker.startSchedule()


                    Connections{
                        target: InternetConnectionChecker
                        function onHasInternetConnectionChanged() {
                            if (InternetConnectionChecker.hasInternetConnection) {
                                Utils.notify(mainPageNotifier, "Connected to internet",
                                             "../../images/svg_images/check_icon.svg", "dark green")
                            } else{
                                Utils.notify(mainPageNotifier, "Disconnected from internet",
                                             "../../images/svg_images/close_icon.svg", "dark red")
                            }
                        }
                    }

                    Notification{
                        id: mainPageNotifier
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        z: parent.z + 1
                    }

                    HomePage{
                        id: pageHome
                        visible: false
                        notifier: mainPageNotifier
                    }

                    MySchedulesPage{
                        id: pageMySchedules
                        visible: false
                        notifier: mainPageNotifier
                    }

                    SettingsPage{
                        id: pageSettings
                        visible: false
                        notifier: mainPageNotifier
                    }

                    StackView {
                        id: stackView
                        anchors.fill: parent
                        clip: true

                        initialItem: pageHome
                    }

                }

                Rectangle {
                    id: rectangle
                    color: "#252931"
                    anchors.left: leftMenu.right
                    anchors.right: parent.right
                    anchors.top: contentPages.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 0

                    Label {
                        id: labelTopInfo1
                        x: -60
                        y: -373
                        color: "#a4a4a4"
                        text: qsTr("App description")
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 10
                        anchors.rightMargin: 30
                        font.pointSize: 8
                    }
                    MouseArea {
                        id: resizeBottomRight
                        width: 25
                        height: 25
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        cursorShape: Qt.SizeFDiagCursor
                        visible: windowStatus === Enums.WindowStatus.Normal

                        DragHandler{
                            target: null
                            onActiveChanged: if(active) mainWindow.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
                        }

                        Image {
                            id: resizeImage
                            opacity: 0.5
                            anchors.fill: parent
                            source: "../images/svg_images/resize_icon.svg"
                            anchors.leftMargin: 5
                            anchors.topMargin: 5
                            sourceSize.height: 16
                            sourceSize.width: 16
                            fillMode: Image.PreserveAspectFit
                            antialiasing: false
                        }
                    }
                }
            }
        }
    }

    DropShadow{
        anchors.fill: background
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10
        samples: 16
        color: "#80000000"
        source: background
        z:0
    }

    MouseArea {
        id: resizeLeft
        width: 10
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor
        visible: windowStatus === Enums.WindowStatus.Normal

        DragHandler{
            target: null
            onActiveChanged: if(active) {mainWindow.startSystemResize((Qt.LeftEdge))}
        }
    }

    MouseArea {
        id: resizeRight
        width: 10
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor
        visible: windowStatus === Enums.WindowStatus.Normal

        DragHandler{
            target: null
            onActiveChanged: if(active) {mainWindow.startSystemResize((Qt.RightEdge))}
        }
    }

    MouseArea {
        id: resizeBottom
        height: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        cursorShape: Qt.SizeVerCursor
        visible: windowStatus === Enums.WindowStatus.Normal

        DragHandler{
            target: null
            onActiveChanged: if(active) {mainWindow.startSystemResize((Qt.BottomEdge))}
        }
    }

    MouseArea {
        id: resizeTop
        height: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        cursorShape: Qt.SizeVerCursor
        visible: windowStatus === Enums.WindowStatus.Normal

        DragHandler{
            target: null
            onActiveChanged: if(active) {mainWindow.startSystemResize((Qt.TopEdge))}
        }
    }

    MouseArea {
        id: resizeBottomLeft
        width: 10
        height: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeBDiagCursor
        visible: windowStatus === Enums.WindowStatus.Normal

        DragHandler{
            target: null
            onActiveChanged: if(active) mainWindow.startSystemResize(Qt.BottomEdge | Qt.LeftEdge)
        }
    }

    MouseArea {
        id: resizeTopLeft
        width: 10
        height: 10
        anchors.left: parent.left
        anchors.top: parent.top
        cursorShape: Qt.SizeFDiagCursor
        visible: windowStatus === Enums.WindowStatus.Normal

        DragHandler{
            target: null
            onActiveChanged: if(active) mainWindow.startSystemResize(Qt.TopEdge | Qt.LeftEdge)
        }
    }

    MouseArea {
        id: resizeTopRight
        width: 10
        height: 10
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.SizeBDiagCursor
        visible: windowStatus === Enums.WindowStatus.Normal

        DragHandler{
            target: null
            onActiveChanged: if(active) mainWindow.startSystemResize(Qt.TopEdge | Qt.RightEdge)
        }
    }



}
