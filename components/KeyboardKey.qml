import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Rectangle {
    id: keyRoot
    height: 60
    width: 45
    color: "#818384"
    radius: 5

    property string keyText: ""
    property int textSize: 24
    property var onClicked: null

    Text {
        text: keyText
        font.pixelSize: keyRoot.textSize
        font.bold: true
        color: "white"
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            if (keyRoot.onClicked) {
                keyRoot.onClicked()
            }
        }
    }
}
