import QtQuick
import QtQuick.Shapes

Shape {
    id: root
    anchors.fill: parent

    required property BorderConfig config

    ShapePath {
        PathRectangle {
            x: root.config.borderThickness + root.config.lineWidth / 2
            y: root.config.borderThickness + root.config.lineWidth / 2
            width: root.width - root.config.borderThickness * 2 - root.config.lineWidth / 2
            height: root.height - root.config.borderThickness * 2 - root.config.lineWidth / 2
            radius: root.config.borderRadius
        }
    }
}
