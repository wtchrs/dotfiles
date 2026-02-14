import QtQuick
import QtQuick.Effects
import Quickshell
import qs.modules.bar
import qs.configs

PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    mask: Region {
        width: root.width
        height: root.height
        Region {
            readonly property int l: Config.border.lineWidth
            readonly property int t: Config.border.thickness + l
            x: t + Config.bar.width
            y: t
            width: root.width - t - Config.bar.width
            height: root.height - t * 2
            intersection: Intersection.Subtract
        }
    }

    Bar { z: 10 }
    BarPlaceholder {}
    BorderShape { id: borderShape }

    // Shadow effect
    MultiEffect {
        anchors.fill: parent
        source: borderShape
        shadowEnabled: true
        shadowBlur: Config.shadow.blur
        shadowColor: Config.shadow.color
        shadowVerticalOffset: Config.shadow.verticalOffset
        shadowHorizontalOffset: config.shadow.horizontalOffset
    }
}
