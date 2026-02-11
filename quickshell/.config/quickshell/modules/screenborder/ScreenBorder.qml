import QtQuick
import QtQuick.Effects
import Quickshell

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

    mask: Region {
        width: root.width
        height: root.height
        Region {
            readonly property int t: root.config.borderThickness + root.config.lineWidth
            x: t
            y: t
            width: root.width - t
            height: root.height - t * 2
            intersection: Intersection.Subtract
        }
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
            shadowVerticalOffset: 3
            shadowHorizontalOffset: 3
        }

        BorderShape {
            id: borderShape
            anchors.fill: parent
            config: root.config
        }
    }
}
