import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "components"


Window {
    visible: true
    width: 640
    height: 800
    title: qsTr("Wordle Game")

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

    StackView {
        id: stackView
        initialItem: /*MainPage {}*/ GamePage {}
        anchors.fill: parent
    }
}
