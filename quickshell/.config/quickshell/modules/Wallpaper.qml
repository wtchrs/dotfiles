import QtQuick
import Quickshell

PanelWindow {
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore
    aboveWindows: false
    color: "transparent"

    Image {
        anchors.fill: parent
        source: Quickshell.env("HOME") + "/Pictures/wallpapers/wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop

        visible: status === Image.Ready
    }
}
