import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Row {
    spacing: 7.5

    property var keys: []

    Repeater {
        model: keys

        KeyboardKey {
            keyText: modelData
            onClicked: function () {
                console.log(modelData + " clicked")
            }
        }
    }
}
