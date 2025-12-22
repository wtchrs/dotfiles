import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    // --- State Properties ---
    property string deviceType: "disconnected" // wifi, ethernet, disconnected, unknown
    property string interfaceName: ""
    property int signalStrength: 0 // 0-100

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    // --- nmcli Data Source (Polling) ---
    Process {
        id: getNetworkProc
        command: ["nmcli", "-t", "-f", "DEVICE,TYPE,STATE,CONNECTION", "dev", "status"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.trim().split('\n');

                // Find a connected device.
                const activeLine = lines.find(line => line.includes("connected"));

                if (activeLine) {
                    const data = activeLine.split(':');

                    root.interfaceName = data[0] || "";
                    root.deviceType = data[1] || "unknown";

                    if (root.deviceType === "wifi") {
                        getSignalProc.running = true;
                    } else if (root.deviceType === "ethernet") {
                        root.signalStrength = 100;
                    }
                } else {
                    // No active connection
                    root.deviceType = "disconnected";
                    root.signalStrength = 0;
                }
            }
        }
    }

    Process {
        id: getSignalProc
        // Link quality may be between 0-70 in Linux network stack.
        command: ["awk", "NR==3 {printf \"%.0f\\n\", ($3/70)*100}", "/proc/net/wireless"]

        stdout: StdioCollector {
            onStreamFinished: {
                const signal = parseInt(text.trim());
                if (!isNaN(signal)) {
                    root.signalStrength = signal;
                } else {
                    // default value for parsing failing
                    root.signalStrength = 0;
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: getNetworkProc.running = true
        Component.onCompleted: getNetworkProc.running = true
    }

    Process {
        id: openNmtui
        command: ["hyprctl", "dispatch", "exec", "[float] ghostty -e nmtui"]
    }

    // --- Helpers ---

    function getIcon() {
        switch (root.deviceType) {
            case "wifi":
                // signal strength icons
                const icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"];
                var idx = Math.floor(root.signalStrength / 20);
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
            color: "white"
            Layout.alignment: Qt.AlignVCenter
            font {
                pixelSize: 16
                family: "Symbols Nerd Font"
            }
        }
    }

    // --- Interaction ---
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: openNmtui.running = true
    }
}
