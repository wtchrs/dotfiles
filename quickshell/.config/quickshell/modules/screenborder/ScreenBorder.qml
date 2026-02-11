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
        item: mouseMask
        intersection: Intersection.Xor
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

        MouseMask {
            id: mouseMask
            anchors.fill: parent
            visible: false
            config: root.config
        }
    }
}
