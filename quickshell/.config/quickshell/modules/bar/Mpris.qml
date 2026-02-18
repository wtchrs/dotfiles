import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.configs

Item {
    id: root
    implicitWidth: Config.bar.width
    implicitHeight: container.implicitHeight

    visible: player !== null && player.trackTitle

    readonly property MprisPlayer player: Mpris.players.values.find(p => p.isPlaying) ?? Mpris.players.values[0]
    readonly property alias hovered: hover.hovered

    HoverHandler {
        id: hover
    }

    MouseArea {
        id: click
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: player.togglePlaying()
    }

    ColumnLayout {
        id: container
        spacing: 4

        anchors.horizontalCenter: parent.horizontalCenter

        RotatedTextIcon {
            id: playerIcon
            text: root.player?.isPlaying ? "▶" : "⏸"
        }

        RotatedMarquee {
            id: marquee
            Layout.fillWidth: true
            // TODO: Add maxHeight custom property and replace height
            height: 150
            text: {
                if (!root.player)
                    return "No media playing";
                if (!root.player.trackArtist)
                    return root.player.trackTitle;
                return `<b>${root.player.trackArtist}</b> - ${root.player.trackTitle}`;
            }
            font.pixelSize: 13
            font.family: "Sarasa Mono K Nerd Font"
            running: root.visible && hovered
        }
    }

    component RotatedTextIcon: Text {
        color: Config.theme.fg
        font.family: Config.font.icon
        font.pixelSize: 13

        transform: [
            Rotation { angle: 90 },
            Translate { x: (parent.width + implicitHeight) / 2 }
        ]
    }
}
