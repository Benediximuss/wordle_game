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
    scale: initScale

    property color fillColor: "transparent"
    property color textColor: "black"
    property string buttonText: ""
    property var textFont: robotoSlabRegular.name
    property var initScale: 1.0
    property bool isBusy: false

    signal clicked

    Text {
        text: buttonRoot.buttonText
        font.family: textFont
        font.pixelSize: 20
        color: buttonRoot.textColor
        anchors.centerIn: parent
        visible: !isBusy
    }

    BusyIndicator {
        running: isBusy
        anchors.centerIn: parent
        scale: 0.7
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        enabled: !isBusy
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
                from: 1 * initScale
                to: 1.05 * initScale
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
                to: 1 * initScale
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
                    to: 0.95 * initScale
                    duration: 75
                }
                NumberAnimation {
                    target: buttonRoot
                    properties: "scale"
                    to: 1 * initScale
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
