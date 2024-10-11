import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

Rectangle {
    anchors.fill: parent
    color: "#e3e3e1"

    Column {
        spacing: 20
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 100
        anchors.rightMargin: 100

        Column {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                source: "qrc:/images/logo.png"
                width: 100
                height: 100
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Wordle"
                font.family: robotoSlabExtraBold.name
                font.pixelSize: 48
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Text {
            text: "Get 6 chances to guess a 5-letter word."
            font.family: robotoSlabRegular.name
            font.pixelSize: 40
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Item {
            height: 10
            width: 1
        }

        Row {
            spacing: 35
            anchors.horizontalCenter: parent.horizontalCenter

            CustomButton {
                buttonText: "Quit"
                onClicked: {
                    console.log("Quiting the game...")
                    Qt.quit()
                }
            }

            CustomButton {
                fillColor: "black"
                buttonText: "Play"
                textColor: "white"
                onClicked: {
                    console.log("Starting the game...")
                    stackView.push("GamePage.qml")
                }
            }
        }
    }
}
