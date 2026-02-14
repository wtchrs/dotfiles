import QtQuick
import Quickshell
import qs.configs

PanelWindow {
    anchors { top: true; bottom: true; left: true }

    exclusiveZone: Config.bar.width

    color: "transparent"
    mask: Region {}
}
