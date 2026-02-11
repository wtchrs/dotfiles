import QtQuick
import Quickshell

PanelWindow {
    anchors { top: true; bottom: true; left: true }

    required property int barWidth
    exclusiveZone: barWidth

    color: "transparent"
    mask: Region {}
}
