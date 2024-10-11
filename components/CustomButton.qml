import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

Rectangle {
    id: buttonRoot
    width: 200
    height: 60
    border.width: 2
    radius: height / 2
    color: fillColor

    property color fillColor: "transparent"
    property color textColor: "black"
    property string buttonText: ""

    signal clicked

    Text {
        text: buttonRoot.buttonText
        font.family: robotoSlabRegular.name
        font.pixelSize: 20
        color: buttonRoot.textColor
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent

        onClicked: {
            buttonRoot.state = "clicked"
        }

        onContainsMouseChanged: {
            if (buttonRoot.state != "clicked") {
                buttonRoot.state = containsMouse ? "mouseIn" : "mouseOut"
            }
        }
    }

    states: ["mouseIn", "mouseOut", "clicked"]
    state: "mouseOut"

    transitions: [
        Transition {
            from: "*"
            to: "mouseIn"
            NumberAnimation {
                target: buttonRoot
                properties: "scale"
                from: 1
                to: 1.05
                duration: 200
            }
            NumberAnimation {
                target: buttonRoot
                property: "opacity"
                from: 1
                to: 0.9
                duration: 200
            }
        },
        Transition {
            from: "*"
            to: "mouseOut"
            NumberAnimation {
                target: buttonRoot
                properties: "scale"
                to: 1
                duration: 200
            }
            NumberAnimation {
                target: buttonRoot
                property: "opacity"
                to: 1
                duration: 200
            }
        },
        Transition {
            from: "*"
            to: "clicked"
            SequentialAnimation {
                NumberAnimation {
                    target: buttonRoot
                    properties: "scale"
                    to: 0.9
                    duration: 75
                }
                NumberAnimation {
                    target: buttonRoot
                    properties: "scale"
                    to: 1
                    duration: 75
                }
                ScriptAction {
                    script: {
                        buttonRoot.clicked()
                        buttonRoot.state = mouseArea.containsMouse ? "mouseIn" : "mouseOut"
                    }
                }
            }
        }
    ]
}
