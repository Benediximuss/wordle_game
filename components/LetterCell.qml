import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Rectangle {
    enum ResultType {
        Wrong,
        Misplaced,
        Correct
    }

    function getResultColor() {
        switch (cellRoot.cellResult) {
        case LetterCell.ResultType.Wrong:
            return cellRoot.fillColorWrong
        case LetterCell.ResultType.Misplaced:
            return cellRoot.fillColorMisplaced
        case LetterCell.ResultType.Correct:
            return cellRoot.fillColorCorrect
        default:
            return "cyan"
        }
    }

    id: cellRoot
    width: 60
    height: 60
    border.width: 2
    radius: 1

    property string cellText
    property int cellResult

    property color fillColorActive: "transparent"
    property color fillColorWrong: "#3a3a3c"
    property color fillColorMisplaced: "#b59f3b"
    property color fillColorCorrect: "#538d4e"

    property color borderColorEmpty: "#3a3a3c"
    property color borderColorNonEmpty: "#565758"
    property color borderColorSealed: "transparent"

    Text {
        text: cellRoot.cellText
        font.pixelSize: 32
        font.bold: true
        color: "white"
        anchors.centerIn: parent
    }

    transform: [
        Scale {
            id: scaleTransform
            origin.x: cellRoot.width / 2
            origin.y: cellRoot.height / 2
            xScale: 1
            yScale: 1
        },
        Rotation {
            id: flipRotation
            origin.x: cellRoot.width / 2
            origin.y: cellRoot.height / 2
            axis.x: 1
            axis.y: 0
            axis.z: 0
        }
    ]

    states: [
        State {
            name: "empty"
            PropertyChanges {
                target: cellRoot
                color: cellRoot.fillColorActive
                border.color: cellRoot.borderColorEmpty
            }
        },
        State {
            name: "nonEmpty"
            PropertyChanges {
                target: cellRoot
                color: cellRoot.fillColorActive
                border.color: cellRoot.borderColorNonEmpty
            }
        },
        State {
            name: "sealed"
            PropertyChanges {
                target: cellRoot
                color: cellRoot.getResultColor()
                border.color: cellRoot.borderColorSealed
            }
        }
    ]

    transitions: [
        Transition {
            from: "empty"
            to: "nonEmpty"
            SequentialAnimation {
                NumberAnimation {
                    target: scaleTransform
                    property: "xScale"
                    from: 1
                    to: 1.1
                    duration: 50
                }
                NumberAnimation {
                    target: scaleTransform
                    property: "xScale"
                    from: 1.1
                    to: 1
                    duration: 50
                }
            }
            SequentialAnimation {
                NumberAnimation {
                    target: scaleTransform
                    property: "yScale"
                    from: 1
                    to: 1.1
                    duration: 50
                }
                NumberAnimation {
                    target: scaleTransform
                    property: "yScale"
                    from: 1.1
                    to: 1
                    duration: 50
                }
            }
        },
        Transition {
            from: "*"
            to: "sealed"
            SequentialAnimation {
                NumberAnimation {
                    target: flipRotation
                    property: "angle"
                    from: 0
                    to: 90
                    duration: 200
                }
                PropertyAction {
                    target: cellRoot
                    property: "color"
                    value: cellRoot.getResultColor()
                }
                PropertyAction {
                    target: cellRoot
                    property: "border.color"
                    value: cellRoot.borderColorSealed
                }
                NumberAnimation {
                    target: flipRotation
                    property: "angle"
                    from: 90
                    to: 0
                    duration: 200
                }
            }
        }
    ]
}
