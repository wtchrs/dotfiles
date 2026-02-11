import QtQuick
import QtQuick.Shapes

Shape {
    id: root
    anchors.fill: parent
    preferredRendererType: Shape.CurveRenderer

    required property BorderConfig config

    readonly property int barw: root.config.barWidth
    readonly property int bt: root.config.borderThickness
    readonly property int br: root.config.borderRadius
    readonly property int lw: root.config.lineWidth

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
            x: barw + bt
            y: bt
            width: root.width - barw - bt * 2
            height: root.height - bt * 2
            radius: br
        }
    }

    ShapePath {
        strokeColor: root.config.lineColor
        strokeWidth: lw
        fillColor: "transparent"

        PathRectangle {
            x: barw + bt + lw / 2
            y: bt + lw / 2
            width: root.width - barw - bt * 2 - lw / 2
            height: root.height - bt * 2 - lw / 2
            radius: br
        }
    }
}
