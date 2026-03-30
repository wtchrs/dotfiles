import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.configs
import qs.modules.bar.state

Item {
    id: root

    readonly property var networkState: NetworkState

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    Process {
        id: openNmtui
        command: ["ghostty", "-e", "nmtui"]
    }

    // --- Helpers ---

    function getIcon() {
        switch (root.networkState.deviceType) {
            case "wifi":
                // signal strength icons
                const icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"];
                const idx = Math.floor(root.networkState.signalStrength / 20);
                return icons[Math.min(idx, 4)];
            case "ethernet":
                return ""; // ethernet icon
            case "disconnected":
                return "󰌙"; // disconnected icon
            default:
                return "󰌙";
        }
    }

    // --- UI Layout (Icon Only) ---
    RowLayout {
        id: container
        anchors.fill: parent
        spacing: 2

        Text {
            id: icon
            text: getIcon()
            color: Config.theme.fg
            Layout.alignment: Qt.AlignVCenter
            font.family: Config.font.icon
            font.pixelSize: 16
        }
    }

    // --- Interaction ---
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: openNmtui.running = true
    }
}
