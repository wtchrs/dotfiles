import QtQuick
import QtQuick.Shapes

Shape {
    id: root
    anchors.fill: parent

    required property int radius
    required property int thickness
    required property color color

    // inner outline
    required property int innerLineWidth
    required property color innerLineColor

    ShapePath {
        PathRectangle {
            x: thickness + 1
            y: thickness + 1
            width: root.width - thickness * 2 - 1
            height: root.height - thickness * 2 - 1
            radius: root.radius
        }
    }
}
