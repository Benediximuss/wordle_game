import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Rectangle {
    anchors.fill: parent
    color: "#121213"

    Column {
        //        anchors.margins: 20 // Use anchors.margins for padding around the column
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 100
        anchors.rightMargin: 100

        spacing: 50

        GridLayout {
            id: wordGrid
            columns: 5
            rows: 6
            rowSpacing: 5
            columnSpacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: 30

                LetterCell {}
            }
        }

        Keyboard {}
    }
}
