import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Row {
    id: rowRoot
    spacing: 7.5

    property var keys: []

    signal keyPressed(string keyText)

    Repeater {
        model: keys

        KeyboardKey {
            keyLetter: modelData
            onKeyPressed: rowRoot.keyPressed(keyText)

        }
    }
}
