import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Rectangle {
    anchors.fill: parent
    color: "#121213"

    property int currentRow: 0
    property int currentCol: 0
    property int totalRows: 6
    property int totalCols: 5

    ListModel {
        id: gridModel
        Component.onCompleted: {
            for (var i = 0; i < totalRows * totalCols; i++) {
                gridModel.append({
                                     "state": "empty",
                                     "cellLetter": "",
                                     "cellResult": LetterCell.ResultType.Wrong
                                 })
            }
        }
    }

    function addLetter(letter) {
        if (currentRow < totalRows) {
            if (currentCol < totalCols) {
                var index = currentRow * totalCols + currentCol
                gridModel.set(index, {
                                  "state": "nonEmpty",
                                  "cellLetter": letter
                              })
                currentCol++
            } else {
                console.log("Cannot add more letters to this row")
            }
        } else {
            console.log("No more rows available.")
        }
    }

    function deleteLetter() {
        if (currentCol > 0) {
            currentCol--
            var index = currentRow * totalCols + currentCol
            gridModel.set(index, {
                              "state": "empty",
                              "cellLetter": ""
                          })
        } else {
            console.log("Nothing to delete in this row")
        }
    }

    property int sealTimerIndex: 0
    property bool isProcessing: false

    function submitWord() {
        if (!isProcessing) {
            if (currentCol === totalCols) {
                isProcessing = true
                var word = ""
                for (var i = 0; i < totalCols; i++) {
                    var index = currentRow * totalCols + i
                    word += gridModel.get(index).cellLetter
                }
                console.log("Word " + word + " has been submitted.")

                sealWord()
            } else {
                console.log("Not enough letters to submit.")
            }
        }
    }

    function sealWord() {
        sealTimerIndex = 0
        sealTimer.start()
    }

    Timer {
        id: sealTimer
        interval: 150
        repeat: true
        onTriggered: {
            if (sealTimerIndex < totalCols) {
                var gridIndex = currentRow * totalCols + sealTimerIndex
                gridModel.set(gridIndex, {
                                  "cellResult": LetterCell.ResultType.Correct,
                                  "state": "sealed"
                              })
                sealTimerIndex++
            } else {
                sealTimer.stop()
                currentRow++
                currentCol = 0
                isProcessing = false
            }
        }
    }

    Column {
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
                model: gridModel

                /*delegate:*/ LetterCell {
                    state: model.state
                    cellText: model.cellLetter
                    cellResult: model.cellResult
                }
            }
        }

        Keyboard {
            onKeyPressed: {
                if (keyText === "ENTER") {
                    submitWord()
                } else if (keyText === "\u232B") {
                    deleteLetter()
                } else {
                    addLetter(keyText)
                }
            }
        }
    }

    Keys.onPressed: {
        var key = event.key
        if (key >= Qt.Key_A && key <= Qt.Key_Z) {
            var letter = event.text.toUpperCase()
            addLetter(letter)
        } else if (key === Qt.Key_Backspace) {
            deleteLetter()
        } else if (key === Qt.Key_Enter || key === Qt.Key_Return) {
            submitWord()
        }
    }
}
