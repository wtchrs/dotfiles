import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

Item {
    id: root

    // --- Configuration (Waybar style) ---
    readonly property int criticalThreshold: 15
    readonly property int warningThreshold: 30
    property bool showTime: false

    // --- UPower Device Access ---
    // Upower.displayDevice indicates primary battery.
    readonly property var battery: UPower.displayDevice

    // UPower State Enums: 0: Unknown, 1: Charging, 2: Discharging, 3: Empty, 4: Fully Charged, 5: Pending Charge ...
    readonly property bool isCharging: battery.state === UPowerDeviceState.Charging
    readonly property bool isFull: battery.state === UPowerDeviceState.FullyCharged
    readonly property bool isPlugged: isCharging || isFull || battery.state === UPowerDeviceState.PendingCharge

    readonly property double percentage: battery.percentage * 100

    implicitWidth: 50
    implicitHeight: container.implicitHeight

    // --- Helpers ---

    function getIcon() {
        if (root.isCharging) return "󰂄";
        if (root.isFull) return "";

        const icons = [" ", " ", " ", " ", " "];

        var idx = Math.min(Math.floor(percentage / 20), 4);
        if (percentage > 0 && idx < 0) idx = 0;

        return icons[idx];
    }

    function getColor() {
        if (root.isCharging) return "#a6da95"; // Green
        if (percentage <= root.criticalThreshold) return "#ed8796"; // Red
        if (percentage <= root.warningThreshold) return "#eed49f"; // Yellow
        return "white";
    }

    function getFormattedTime() {
        let seconds = 0;
        if (root.isCharging) {
            seconds = battery.timeToFull;
        } else {
            seconds = battery.timeToEmpty;
        }

        if (seconds <= 0) return "";

        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);

        if (h > 0) return `${h}h ${m}m`;
        return `${m}m`;
    }

    // --- UI Layout ---

    RowLayout {
        id: container
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2

        Text {
            id: icon
            text: getIcon()
            color: getColor()
            font {
                pixelSize: 14
                family: "Symbols Nerd Font"
            }
        }

        // Info (Percentage or Time)
        Text {
            text: {
                if (root.showTime) {
                    const timeStr = getFormattedTime();
                    return timeStr !== "" ? timeStr : "Calc...";
                } else {
                    return Math.round(percentage) + "%";
                }
            }
            color: getColor()
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
        onClicked: root.showTime = !root.showTime
    }
}
