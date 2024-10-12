import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

StackPage {
    enum GameStatus {
        Running,
        Won,
        Lost
    }

    color: "#121213"

    property int currentRow: 0
    property int currentCol: 0
    property int totalRows: 6
    property int totalCols: 5

    property int gameStatus: GamePage.GameStatus.Running

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

    //    property int sealTimerIndex: 0
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

                GameManager.enterGuess(word)
            } else {
                console.log("Not enough letters to submit.")
            }
        }
    }

    function returnToMenu() {
        StackView.view.pop()
    }

    //    function sealWord() {
    //        sealTimerIndex = 0
    //        sealTimer.start()
    //    }
    Connections {
        target: GameManager
        onInvalidGuess: {
            console.log("Invalid word!")
            isProcessing = false
        }
        onGuessResult: {
            for (var i = 0; i < guessResult.length; i++) {
                var gridIndex = currentRow * totalCols + i
                gridModel.set(gridIndex, {
                                  "cellResult": guessResult[i],
                                  "state": "sealed"
                              })
            }

            currentRow++
            currentCol = 0
            isProcessing = false

            gameStatus = currentStatus
        }
    }

    //    Timer {
    //        id: sealTimer
    //        interval: 150
    //        repeat: true
    //        onTriggered: {
    //            if (sealTimerIndex < totalCols) {
    //                var gridIndex = currentRow * totalCols + sealTimerIndex
    //                gridModel.set(gridIndex, {
    //                                  "cellResult": LetterCell.ResultType.Correct,
    //                                  "state": "sealed"
    //                              })
    //                sealTimerIndex++
    //            } else {
    //                sealTimer.stop()
    //                currentRow++
    //                currentCol = 0
    //                isProcessing = false
    //            }
    //        }
    //    }
    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 60
        anchors.rightMargin: 60

        spacing: 30

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                Text {
                    id: titleText
                    text: "WORDLE"
                    font.pixelSize: 32
                    color: "white"
                    font.family: robotoSlabExtraBold.name
                    anchors.verticalCenter: parent.verticalCenter
                }
                CustomButton {
                    buttonText: "Return to menu"
                    textColor: "White"
                    fillColor: "#818384"
                    textFont: robotoSlabExtraBold.name
                    initScale: 0.8
                    anchors.verticalCenter: parent.verticalCenter
                    visible: gameStatus !== GamePage.GameStatus.Running
                    onClicked: returnToMenu()
                }

                state: "running"
                states: [
                    State {
                        name: "won"
                        when: gameStatus === GamePage.GameStatus.Won
                        PropertyChanges {
                            target: titleText
                            text: "You Won!"
                        }
                    },
                    State {
                        name: "lost"
                        when: gameStatus === GamePage.GameStatus.Lost
                        PropertyChanges {
                            target: titleText
                            text: "You Lost!"
                        }
                    }
                ]
            }
            Rectangle {
                height: 1
                color: "#818384"
                anchors.left: parent.left
                anchors.right: parent.right
            }
            Row {
                visible: gameStatus === GamePage.GameStatus.Lost
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Text {
                    text: "The word was:"
                    font.pixelSize: 18
                    color: "white"
                    font.family: robotoSlabRegular.name
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: GameManager.getTargetWord()
                    font.pixelSize: 24
                    color: "white"
                    font.family: robotoSlabExtraBold.name
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        GridLayout {
            id: wordGrid
            columns: 5
            rows: 6
            rowSpacing: 5
            columnSpacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: gridModel

                LetterCell {
                    state: model.state
                    cellText: model.cellLetter
                    cellResult: model.cellResult
                }
            }
        }

        Keyboard {
            onKeyPressed: {
                if (gameStatus === GamePage.GameStatus.Running
                        && !isProcessing) {
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
    }

    Keys.onPressed: {
        if (gameStatus === GamePage.GameStatus.Running && !isProcessing) {
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
}
