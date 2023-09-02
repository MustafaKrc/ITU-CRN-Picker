import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts


//import "../../../core/ItuLogin" 1.0
//import core.ItuLogin 1.0
import "../panels"


Item {
    id: homePage



    Rectangle {
        id: background
        color: "#2c313c"
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
        //compactMode: LoginPanel.CompactMode.SmallTopRight
    }

    AppPanel {
        id: appPanel
        anchors.fill: parent
        backgroundColor: "#00ffffff"
        opacity: 0
        visible: false
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
                target: appPanel
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
