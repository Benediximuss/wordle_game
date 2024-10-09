import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

Window {
    visible: true
    width: 640
    height: 800
    title: qsTr("Wordle Game")
    color: "#e3e3e1"

    x: /*Screen.width*/ -15 - width
    y: 100

    Shortcut {
        sequence: "Esc"
        onActivated: Qt.quit()
    }

    FontLoader {
        id: robotoSlabRegular
        source: "qrc:/fonts/Roboto_Slab/RobotoSlab-Regular.ttf"
    }
    FontLoader {
        id: robotoSlabExtraBold
        source: "qrc:/fonts/Roboto_Slab/RobotoSlab-ExtraBold.ttf"
    }

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
                onClicked: function () {
                    console.log("Quiting the game...")
                    Qt.quit()
                }
            }

            CustomButton {
                fillColor: "black"
                buttonText: "Play"
                textColor: "white"
                onClicked: function () {
                    console.log("Starting the game...")
                }
            }
        }
    }
}
