import QtQuick 2.15
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

// belki kendi validatorunu yap...

Item{
    id: setting
    // properties
    property color inputColorDefault: "#1c1d20"
    property color inputColorMouseOver: "#36373c"

    property string value: "placeholder value"

    property string settingText: "placeholder text"
    property color settingTextColor: "#ffffff"

    property color inputSelectionColor: "#64769e"

    property int inputTextMaxSize: 40
    property int spacing: 5
    property int alignMode: SettingSwitchButton.Align.Left

    property int inputValidator: SettingInputBox.Validator.String

    property real minimum : Number.NEGATIVE_INFINITY
    property real maximum : Number.POSITIVE_INFINITY
    property real edgeCase : Number.POSITIVE_INFINITY

    width: 150
    height: 50

    enum Validator{
        String,
        Integer,
        Double
    }
    //Qt.ImhDate - The text editor functions as a date field.

    enum Align{
        HorizontalCenter,
        Left
    }


    Item{
        id: container
        anchors.centerIn: parent
        height: parent.height
        width: Math.min(parent.width,
                        alignMode === SettingSwitchButton.Align.Left ? parent.width
                                                                     : buttonSwitch.width
                                                                       + textDescription.paintedWidth
                                                                       + textDescription.anchors.leftMargin
                        )

        Rectangle{
            id: textInputBackground
            height: 50
            width: textInput.width + 10
            radius: 10

            property bool hovered: false

            color: textInputBackground.hovered ? inputColorMouseOver : inputColorDefault
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: textInputBackground.hovered = true
                onExited: textInputBackground.hovered = false
            }

            TextInput{
                width: Math.min(Math.max(10,implicitWidth),150)
                height: 50
                id: textInput
                text: value
                verticalAlignment: Text.AlignVCenter
                selectionColor: inputSelectionColor
                anchors.horizontalCenter: parent.horizontalCenter
                selectByMouse: true
                color: settingTextColor
                font.pixelSize: 0.5 * parent.height

                property string fallbackValue
                Component.onCompleted: fallbackValue = text // getting rid of property binding

                onEditingFinished: if(!validate(inputValidator,text)){
                                       text = fallbackValue
                                   } else{
                                       fallbackValue = text
                                       value = text
                                   }

                //https://doc.qt.io/qt-5/qml-qtquick-controls-textfield.html
                //inputMethodHints: Qt.ImhFormattedNumbersOnly // have no effect

                /*
                // for some reason validator property does not work...
                validator: if(inputValidator === SettingInputBox.Validator.Integer){
                               IntValidator
                           } else if(inputValidator === SettingInputBox.Validator.Double){
                               DoubleValidator
                           }
                */

                function validate(type, string){
                    if(string.trim() === "" || string.trim() === "-" || string.trim() === "+") return false;

                    if(inputValidator === SettingInputBox.Validator.String){
                        return true;
                    }
                    else if(inputValidator === SettingInputBox.Validator.Integer){
                        const integerVal = parseInt(string, 10);
                        // if string is integer
                        if(integerVal.toString() === string && Number.isInteger(integerVal)){
                            return inBounds(integerVal)
                        }
                        return false;
                    }
                    else if(inputValidator === SettingInputBox.Validator.Double){
                        if(isNaN(string)) return false;

                        return inBounds(parseFloat(string));
                    }
                }

                function inBounds(value){
                    if(value === edgeCase) return true;
                    return value <= maximum && value >= minimum;
                }
            }
        }

        Text {
            id: textDescription
            text: settingText
            anchors.left: textInputBackground.right
            anchors.leftMargin: spacing

            width: Math.min(implicitWidth, setting.width - textInput.width - anchors.leftMargin)
            height: parent.height

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            wrapMode: Text.WordWrap
            color: settingTextColor
            fontSizeMode: Text.Fit

            minimumPixelSize: 10
            minimumPointSize: 10
            font.pointSize: 60
        }
    }
}
