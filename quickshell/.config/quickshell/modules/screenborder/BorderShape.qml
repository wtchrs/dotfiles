import QtQuick
import QtQuick.Shapes
import qs.configs

Shape {
    id: root
    anchors.fill: parent
    preferredRendererType: Shape.CurveRenderer

    readonly property int barw: Config.bar.width
    readonly property int bt: Config.border.thickness
    readonly property int br: Config.border.radius
    readonly property int lw: Config.border.lineWidth

    ShapePath {
        fillColor: Config.theme.bg
        fillRule: ShapePath.OddEvenFill
        strokeColor: Config.theme.bg

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
        strokeColor: Config.theme.br
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
