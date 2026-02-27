import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

PanelWindow {
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.namespace: "quickshell:backdrop"
    WlrLayershell.layer: WlrLayer.Background

    exclusionMode: ExclusionMode.Ignore
    aboveWindows: false
    color: "transparent"

    Image {
        id: image
        anchors.fill: parent
        source: Quickshell.env("HOME") + "/Pictures/wallpapers/wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop

        visible: status === Image.Ready
    }

    MultiEffect {
        anchors.fill: parent
        source: image
        blurEnabled: true
        blur: 0.8
        blurMax: 35
        blurMultiplier: 0.2
    }
}
