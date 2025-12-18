import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    property real volume: 0.5
    property bool muted: false

    width: 50
    height: container.implicitHeight

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
            color: "white"
            font {
                pixelSize: 18
                family: "Symbols Nerd Font"
            }
        }

        Text {
            text: root.muted ? "Muted" : `${Math.round(root.volume * 100)}%`
            color: "white"
            font {
                pixelSize: 14
                family: "Sarasa Mono K"
            }
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
