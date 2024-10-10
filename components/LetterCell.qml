import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Rectangle {
    width: 60
    height: 60
    border.width: 2
    border.color: "#3a3a3c"
    color: "transparent"
    radius: 2.5
    
    Text {
        text: "Q" // You will set this dynamically based on guesses
        font.pixelSize: 32
        font.bold: true
        color: "white"
        anchors.centerIn: parent
    }
}
