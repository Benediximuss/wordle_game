import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Rectangle {
    id: keyRoot
    height: 60
    width: 45
    color: "#818384"
    radius: 5

    property string keyLetter: ""
    property int textSize: 24

    signal keyPressed(string keyText)

    Text {
        text: keyRoot.keyLetter
        font.pixelSize: keyRoot.textSize
        font.bold: true
        color: "white"
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            keyRoot.state = "pressed"
        }
        onReleased: {
            keyRoot.state = ""
            keyRoot.keyPressed(keyRoot.keyLetter)
        }
        onCanceled: {
            keyRoot.state = ""
        }
    }

    states: [
        State {
            name: "pressed"
            when: mouseArea.pressed
            PropertyChanges {
                target: keyRoot
                scale: 0.95
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "pressed"
            NumberAnimation {
                properties: "scale"
                duration: 50
                easing.type: Easing.OutQuad
            }
        },
        Transition {
            from: "pressed"
            to: ""
            NumberAnimation {
                properties: "scale"
                duration: 50
                easing.type: Easing.OutQuad
            }
        }
    ]
}
