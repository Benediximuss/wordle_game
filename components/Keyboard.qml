import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Column {
    id: keyboardRoot
    spacing: 10
    anchors.horizontalCenter: parent.horizontalCenter

    signal keyPressed(string keyText)

    KeyboardRow {
        anchors.horizontalCenter: parent.horizontalCenter
        keys: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        onKeyPressed: keyboardRoot.keyPressed(keyText)
    }
    KeyboardRow {
        anchors.horizontalCenter: parent.horizontalCenter
        keys: ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        onKeyPressed: keyboardRoot.keyPressed(keyText)
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 7.5

        KeyboardKey {
            keyLetter: "ENTER"
            width: 60
            textSize: 16
            onKeyPressed: keyboardRoot.keyPressed(keyText)
        }

        KeyboardRow {
            keys: ["Z", "X", "C", "V", "B", "N", "M"]
            onKeyPressed: keyboardRoot.keyPressed(keyText)
        }

        KeyboardKey {
            keyLetter: "\u232B"
            width: 60
            onKeyPressed: keyboardRoot.keyPressed(keyText)
        }
    }
}
