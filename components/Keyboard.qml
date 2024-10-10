import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Column {
    spacing: 10
    anchors.horizontalCenter: parent.horizontalCenter

    KeyboardRow {
        anchors.horizontalCenter: parent.horizontalCenter
        keys: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
    }
    KeyboardRow {
        anchors.horizontalCenter: parent.horizontalCenter
        keys: ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 7.5

        KeyboardKey {
            keyText: "ENTER"
            width: 60
            textSize: 16
            onClicked: function () {
                console.log("Word submitted")
            }
        }

        KeyboardRow {
            keys: ["Z", "X", "C", "V", "B", "N", "M"]
        }

        KeyboardKey {
            keyText: "\u232B"
            width: 60
            onClicked: function () {
                console.log("Letter deleted")
            }
        }
    }
}
