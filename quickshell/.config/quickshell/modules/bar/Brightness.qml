import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.configs
import qs.modules.bar.state

Item {
    id: root

    property string device: BrightnessState.device
    readonly property var brightnessState: BrightnessState

    implicitWidth: Config.bar.width
    implicitHeight: container.implicitHeight

    onDeviceChanged: {
        if (root.device !== root.brightnessState.device)
            root.brightnessState.setDevice(root.device)
    }

    // --- Helpers ---

    function getIcon() {
        const icons = [" ", " ", " ", " ", " "];
        const level = root.brightnessState.ready || root.brightnessState.everReady
            ? root.brightnessState.brightness
            : 0;
        var idx = Math.min(Math.floor(level / 20), 4);
        if (level > 0 && idx < 0) idx = 0;
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
            color: Config.theme.fg
            font.family: Config.font.icon
            font.pixelSize: 14
        }

        Text {
            text: root.brightnessState.ready || root.brightnessState.everReady
                ? `${root.brightnessState.brightness}%`
                : "--"
            color: Config.theme.fg
            font.family: Config.font.text
            font.pixelSize: 14
        }
    }

    // --- Interaction ---

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onWheel: {
            if (wheel.angleDelta.y > 0) {
                root.brightnessState.increase();
            } else {
                root.brightnessState.decrease();
            }
        }
    }
}
