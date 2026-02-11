import QtQuick
import QtQuick.Effects
import Quickshell
import "../bar"

PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    property BorderConfig config: BorderConfig {}

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    mask: Region {
        width: root.width
        height: root.height
        Region {
            readonly property int l: root.config.lineWidth
            readonly property int t: root.config.borderThickness + l
            x: t + root.config.barWidth
            y: t
            width: root.width - t - root.config.barWidth
            height: root.height - t * 2
            intersection: Intersection.Subtract
        }
    }

    Bar {
        barWidth: root.config.barWidth
        z: 10
    }

    BarPlaceholder {
        barWidth: root.config.barWidth
    }

    Item {
        id: borderRoot
        anchors.fill: parent
        enabled: false

        MultiEffect {
            anchors.fill: parent
            source: borderShape
            shadowEnabled: true
            shadowBlur: 0.8
            shadowColor: "#90000000"
            shadowVerticalOffset: 2
            shadowHorizontalOffset: 2
        }

        BorderShape {
            id: borderShape
            anchors.fill: parent
            config: root.config
        }
    }
}
