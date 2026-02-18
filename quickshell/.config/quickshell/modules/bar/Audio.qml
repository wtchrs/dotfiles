import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.configs

Item {
    id: root

    property real volume: 0.5
    property bool muted: false

    implicitWidth: Config.bar.width
    implicitHeight: container.implicitHeight

    Process {
        id: getVolumeProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                var output = text;
                var matches = output.match(/Volume: ([\d.]+)( \[MUTED\])?/);
                if (matches) {
                    root.volume = parseFloat(matches[1]);
                    root.muted = (matches[2] !== undefined);
                }
            }
        }
    }

    Process { id: volumeUpProc; command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "1%+"]; onExited: getVolumeProc.running = true }
    Process { id: volumeDownProc; command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "1%-"]; onExited: getVolumeProc.running = true }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: getVolumeProc.running = true
        Component.onCompleted: getVolumeProc.running = true
    }

    RowLayout {
        id: container
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2

        Text {
            id: volumeIcon
            text: {
                if (root.muted || root.volume == 0) return "󰝟";
                if (root.volume < 0.5) return "󰕿";
                return "󰕾";
            }
            color: Config.theme.fg
            font.family: Config.font.icon
            font.pixelSize: 18
        }

        Text {
            text: root.muted ? "Muted" : `${Math.round(root.volume * 100)}%`
            color: Config.theme.fg
            font.family: Config.font.text
            font.pixelSize: 14
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.PointingHandCursor
        onWheel: {
            if (wheel.angleDelta.y > 0) {
                volumeUpProc.running = true;
            } else {
                volumeDownProc.running = true;
            }
        }
    }
}
