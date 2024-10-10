import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Rectangle {
    width: 40
    height: 40
    color: "lightgray" // Placeholder color for the icon background
    radius: 8

    // Placeholder for the icon
    Text {
        anchors.centerIn: parent
        text: "\u2605" // Placeholder star icon (Unicode star character)
        font.pixelSize: 24
        color: "black"
    }

    // Customizable behavior or properties
    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("CustomIcon clicked!")
        }
    }
}
