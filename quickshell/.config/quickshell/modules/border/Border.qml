import QtQuick
import QtQuick.Effects
import Quickshell

PanelWindow {
    id: root

    mask: Region {
        item: mouseMask
        intersection: Intersection.Xor
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    property int borderThickness: 3
    property int borderRadius: 15
    property color borderColor: "#FF000000"
    property int lineWidth: 2
    property color lineColor: "#FF555555"

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

            radius: borderRadius
            thickness: borderThickness
            color: borderColor
            innerLineWidth: lineWidth
            innerLineColor: lineColor
        }

        MouseMask {
            id: mouseMask
            anchors.fill: parent
            visible: false

            radius: borderRadius
            thickness: borderThickness
            color: borderColor
            innerLineWidth: lineWidth
            innerLineColor: lineColor
        }
    }
}
