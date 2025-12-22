import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

Item {
    id: root
    implicitWidth: 50
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

        RotatedText {
            id: playerIcon
            text: root.player?.isPlaying ? "▶" : "⏸"
        }

        RotatedMarquee {
            id: marquee
            Layout.fillWidth: true
            // Layout.fillHeight: true
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

    component RotatedText: Text {
        color: "white"
        font.pixelSize: 13
        font.family: "Sarasa Mono K Nerd Font"

        transform: [
            Rotation { angle: 90 },
            Translate { x: (parent.width + implicitHeight) / 2 }
        ]
    }
}
