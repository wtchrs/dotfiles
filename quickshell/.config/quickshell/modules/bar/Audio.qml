import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.configs
import qs.modules.bar.state

Item {
    id: root

    readonly property var audioState: AudioState

    implicitWidth: Config.bar.width
    implicitHeight: container.implicitHeight

    RowLayout {
        id: container
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2

        Text {
            id: volumeIcon
            text: {
                if (!root.audioState.everValid) return "󰕾";
                if (root.audioState.muted || root.audioState.volume === 0) return "󰝟";
                if (root.audioState.volume < 0.5) return "󰕿";
                return "󰕾";
            }
            color: Config.theme.fg
            font.family: Config.font.icon
            font.pixelSize: 18
        }

        Text {
            text: {
                if (!root.audioState.everValid) return "--";
                return root.audioState.muted ? "Muted" : `${Math.round(root.audioState.volume * 100)}%`;
            }
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
                root.audioState.increase();
            } else {
                root.audioState.decrease();
            }
        }
    }
}
