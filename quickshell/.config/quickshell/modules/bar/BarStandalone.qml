import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import qs.configs

PanelWindow {
    id: barWin

    WlrLayershell.namespace: "quickshell:blur"

    anchors {
        top: true
        bottom: true
        left: true
    }
    implicitWidth: barBg.implicitWidth + barBr.implicitWidth

    color: "transparent"

    Bar { z: 10 }

    Rectangle {
        id: barBg
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        implicitWidth: Config.bar.width
        color: Config.theme.bg
    }

    Rectangle {
        id: barBr
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: barBg.right
        }
        implicitWidth: Config.border.lineWidth
        color: Config.theme.br
    }
}
