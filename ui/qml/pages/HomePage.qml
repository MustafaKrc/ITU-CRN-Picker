import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

import "../../../core/ItuLogin" 1.0
import "../panels"


Item {
    Rectangle {
        id: rectangle
        color: "#2c313c"
        anchors.fill: parent

    }


    LoginPanel{
        id: loginPanel
        width: parent.width/3
        height: 3*parent.height/4
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
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
