import QtQuick 2.9
import QtQuick.Shapes 1.15

Shape {
    id: root
    width: 400
    height: 400

    property real borderWidth: 2
    property color borderColor: "#000000"
    signal imageDropped(string imageUrl)

    ShapePath {
        strokeWidth: root.borderWidth
        strokeColor: root.borderColor
        fillColor: "#00000000"
        strokeStyle: ShapePath.DashLine
        dashPattern: [ 7, 5 ]
        startX: 0
        startY: 0
        PathLine { x: 0; y: root.height }
        PathLine { x: root.width; y: root.height }
        PathLine { x: root.width; y: 0 }
        PathLine { x: 0; y: 0 }
    }

    ImageDropArea {
        id: firstDropArea
        anchors.fill: parent
        backgroundRadius: 10
        onImageDropped: function (imageUrl) {
            root.imageDropped(imageUrl)
        }
    }
}