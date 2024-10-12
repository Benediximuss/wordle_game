import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Rectangle {
    enum LetterStatus {
        Wrong,
        Misplaced,
        Correct
    }

    id: keyRoot
    height: 60
    width: 45
    color: fillColorNotUsed
    radius: 5

    property string keyLetter: ""
    property int textSize: 24

    property color fillColorNotUsed: "#818384"
    property color fillColorWrong: "#3a3a3c"
    property color fillColorMisplaced: "#b59f3b"
    property color fillColorCorrect: "#538d4e"

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

    Connections {
        target: GameManager
        onLetterUsed: {
            var newColor
            if (letter == keyLetter) {
                switch (status) {
                case LetterCell.ResultType.Wrong:
                    newColor = keyRoot.fillColorWrong
                    break
                case LetterCell.ResultType.Misplaced:
                    newColor = keyRoot.fillColorMisplaced
                    break
                case LetterCell.ResultType.Correct:
                    newColor = keyRoot.fillColorCorrect
                    break
                default:
                    newColor = fillColorNotUsed
                }

                keyRoot.color = newColor
            }
        }
    }
}
