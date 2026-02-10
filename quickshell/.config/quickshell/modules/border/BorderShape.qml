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
        fillColor: color
        fillRule: ShapePath.OddEvenFill
        strokeColor: color

        PathRectangle {
            x: 0; y: 0
            width: root.width
            height: root.height
        }

        PathRectangle {
            x: thickness
            y: thickness
            width: root.width - thickness * 2
            height: root.height - thickness * 2
            radius: root.radius
        }
    }

    ShapePath {
        strokeColor: innerLineColor
        strokeWidth: innerLineWidth
        fillColor: "transparent"

        PathRectangle {
            x: thickness + 1
            y: thickness + 1
            width: root.width - thickness * 2 - 1
            height: root.height - thickness * 2 - 1
            radius: root.radius
        }
    }
}
