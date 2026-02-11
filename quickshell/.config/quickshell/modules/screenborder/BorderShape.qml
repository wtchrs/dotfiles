import QtQuick
import QtQuick.Shapes

Shape {
    id: root
    anchors.fill: parent

    required property BorderConfig config

    ShapePath {
        fillColor: root.config.borderColor
        fillRule: ShapePath.OddEvenFill
        strokeColor: root.config.borderColor

        PathRectangle {
            x: 0; y: 0
            width: root.width
            height: root.height
        }

        PathRectangle {
            x: root.config.borderThickness
            y: root.config.borderThickness
            width: root.width - root.config.borderThickness * 2
            height: root.height - root.config.borderThickness * 2
            radius: root.config.borderRadius
        }
    }

    ShapePath {
        strokeColor: root.config.lineColor
        strokeWidth: root.config.lineWidth
        fillColor: "transparent"

        PathRectangle {
            x: root.config.borderThickness + root.config.lineWidth / 2
            y: root.config.borderThickness + root.config.lineWidth / 2
            width: root.width - root.config.borderThickness * 2 - root.config.lineWidth / 2
            height: root.height - root.config.borderThickness * 2 - root.config.lineWidth / 2
            radius: root.config.borderRadius
        }
    }
}
