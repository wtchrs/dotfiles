import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    // --- Configuration ---
    property string device: "intel_backlight"
    property int brightness: 0

    width: 50
    height: container.implicitHeight

    // --- Logic ---

    // Polling brightness
    Process {
        id: getBrightnessProc
        command: ["brightnessctl", "-d", root.device, "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                // comma separated informations of the brightness device
                var output = text.trim();
                var parts = output.split(",");
                if (parts.length > 0) {
                    var percentage = parts[3];
                    var pct = parseInt(percentage.replace("%", ""));
                    if (!isNaN(pct)) {
                        root.brightness = pct;
                    }
                }
            }
        }
    }

    // Adjust brightness using scroll
    Process { id: incBrightness; command: ["brightnessctl", "-d", root.device, "set", "1%+"]; onExited: getBrightnessProc.running = true }
    Process { id: decBrightness; command: ["brightnessctl", "-d", root.device, "set", "1%-"]; onExited: getBrightnessProc.running = true }

    // Periodic polling to detect changes outside of Quickshell
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: getBrightnessProc.running = true
        Component.onCompleted: getBrightnessProc.running = true
    }

    // --- Helpers ---

    function getIcon() {
        const icons = [" ", " ", " ", " ", " "];
        var idx = Math.min(Math.floor(root.brightness / 20), 4);
        if (root.brightness > 0 && idx < 0) idx = 0;
        return icons[idx];
    }

    // --- UI Layout ---

    RowLayout {
        id: container
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0

        Text {
            id: icon
            text: getIcon()
            color: "white"
            font {
                pixelSize: 14
                family: "Symbols Nerd Font"
            }
        }

        Text {
            text: root.brightness + "%"
            color: "white"
            font {
                pixelSize: 14
                family: "Sarasa Mono K"
            }
        }
    }

    // --- Interaction ---

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onWheel: {
            if (wheel.angleDelta.y > 0) {
                incBrightness.running = true;
            } else {
                decBrightness.running = true;
            }
            getBrightnessProc.running = true;
        }
    }
}
