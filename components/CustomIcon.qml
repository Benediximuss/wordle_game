import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Rectangle {
    width: 40
    height: 40
    color: "lightgray"
    radius: 8

    Text {
        anchors.centerIn: parent
        text: "\u2605"
        font.pixelSize: 24
        color: "black"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("CustomIcon clicked!")
        }
    }
}
