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

    property int order: SettingInputBox.Order.SettingFirst

    property real minimum : Number.NEGATIVE_INFINITY
    property real maximum : Number.POSITIVE_INFINITY
    property real edgeCase : Number.POSITIVE_INFINITY

    property real inputToDescWidthRatio: 1
    property real maximumTextSize: 60
    property real minimumTextSize : 12

    property var binderFunction : function(parent) {console.log(parent,"=> provide a binder function!")}


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

    enum Order{
        DescriptionFirst,
        SettingFirst
    }


    Item{
        id: container
        anchors.centerIn: parent
        height: parent.height
        width: Math.min(parent.width,
                        alignMode === SettingSwitchButton.Align.Left ? parent.width
                                                                     : buttonSwitch.width
                                                                       + textDescription.paintedWidth
                                                                       + textDescription.anchors.leftMargin)

        Rectangle{
            id: textInputBackground
            height: 50
            width: textInput.width + 10
            radius: 10
            anchors.verticalCenter: parent.verticalCenter


            anchors.left: order === SettingInputBox.Order.DescriptionFirst ? textDescription.right : undefined
            anchors.leftMargin: order === SettingInputBox.Order.DescriptionFirst ? spacing : 0

            property bool hovered: false

            color: textInputBackground.hovered ? inputColorMouseOver : inputColorDefault
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: textInputBackground.hovered = true
                onExited: textInputBackground.hovered = false
            }

            TextInput{
                width: Math.min(Math.max(10, implicitWidth),
                                Math.max(setting.width - textDescription.implicitWidth,
                                         setting.width * (inputToDescWidthRatio < 1 ? inputToDescWidthRatio :
                                                                                      inputToDescWidthRatio / (inputToDescWidthRatio+1))))
                height: 50
                id: textInput
                //text: value
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                clip: true
                selectionColor: inputSelectionColor
                selectByMouse: true
                anchors.horizontalCenter: parent.horizontalCenter
                color: settingTextColor
                font.pixelSize: Math.min(container.height * 0.5, maximumTextSize)

                property string fallbackValue
                Component.onCompleted: {
                    text = value
                    fallbackValue = text // getting rid of property binding
                }

                onEditingFinished: if(!validate(inputValidator,text)){
                                       text = fallbackValue
                                   } else{
                                       fallbackValue = text
                                       binderFunction(textInput)
                                   }

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
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: order === SettingInputBox.Order.SettingFirst ? textInputBackground.right : container.left
            anchors.leftMargin: order === SettingInputBox.Order.SettingFirst ? spacing : 0

            width: Math.min(implicitWidth, setting.width - textInput.width - anchors.leftMargin,
                            Math.max(setting.width - textInput.implicitWidth,
                                     setting.width * (inputToDescWidthRatio < 1 ? (1 - inputToDescWidthRatio) :
                                                                                  1 / (inputToDescWidthRatio+1))))
            height: parent.height

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            wrapMode: Text.WordWrap
            color: settingTextColor
            fontSizeMode: Text.Fit

            font.pixelSize: Math.min(Math.max(minimumTextSize, container.height), maximumTextSize)
        }
    }
}
