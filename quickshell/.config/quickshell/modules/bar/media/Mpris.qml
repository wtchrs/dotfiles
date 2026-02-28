import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.configs

Item {
    id: root

    // ----- Public API -----
    property int widthHint: Config.bar.width
    property int marqueeHeight: 150
    property int spacing: 4

    property bool showWhenIdle: false
    property bool requireTrackTitle: true
    property string idleText: "No media playing"

    property bool toggleOnClick: true
    property bool marqueeOnHover: true

    property string playingIcon: "▶ "
    property string pausedIcon: "⏸ "
    property string idleIcon: "♪ "

    property font iconFont: Qt.font({ family: Config.font.icon, pixelSize: 13 })
    property font textFont: Qt.font({ family: Config.font.text, pixelSize: 13 })
    property color foregroundColor: Config.theme.fg

    // Allow player selection policy to be injected from outside
    // function(players) -> MprisPlayer|null
    property var playerSelector: null

    // Allow string formatting policy to be injected from outside
    // function(player) -> string
    property var trackTextFormatter: null

    // ----- Derived / Internal -----
    implicitWidth: root.widthHint
    implicitHeight: container.implicitHeight

    readonly property var players: Mpris.players?.values ?? []

    function defaultPickPlayer(playersList) {
        if (!playersList || playersList.length === 0)
            return null
        return playersList.find(p => p && p.isPlaying) || playersList[0] || null
    }

    readonly property MprisPlayer player: {
        const list = root.players
        if (root.playerSelector) {
            const picked = root.playerSelector(list)
            return picked || root.defaultPickPlayer(list)
        }
        return root.defaultPickPlayer(list)
    }

    readonly property bool hasTrackInfo: {
        if (!root.player)
            return false
        if (root.requireTrackTitle)
            return !!root.player.trackTitle
        return !!(root.player.trackTitle || root.player.trackArtist)
    }

    visible: root.showWhenIdle || root.hasTrackInfo

    readonly property alias hovered: hover.hovered

    function htmlEscape(s) {
        const v = (s === null || s === undefined) ? "" : String(s)
        if (Qt.htmlEscaped) return Qt.htmlEscaped(v)
        return v
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;")
    }

    function defaultTrackText(playerObj) {
        if (!playerObj)
            return root.idleText

        const title = playerObj.trackTitle ? String(playerObj.trackTitle) : ""
        const artist = playerObj.trackArtist ? String(playerObj.trackArtist) : ""

        if (!title && !artist)
            return root.idleText
        if (!artist)
            return root.htmlEscape(title)

        return `<b>${root.htmlEscape(artist)}</b> - ${root.htmlEscape(title)}`
    }

    readonly property string trackText: {
        if (root.trackTextFormatter)
            return String(root.trackTextFormatter(root.player))
        return root.defaultTrackText(root.player)
    }

    readonly property string statusIconText: {
        if (!root.player)
            return root.idleIcon
        return root.player.isPlaying ? root.playingIcon : root.pausedIcon
    }

    signal clicked(MprisPlayer player)

    HoverHandler { id: hover }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        enabled: !!root.player

        onClicked: {
            root.clicked(root.player)
            if (root.toggleOnClick && root.player)
                root.player.togglePlaying()
        }
    }

    ColumnLayout {
        id: container
        spacing: root.spacing
        implicitWidth: root.widthHint
        anchors.horizontalCenter: parent.horizontalCenter

        RotatedLabel {
            text: root.statusIconText
            font: root.iconFont
            color: root.foregroundColor
            angle: 90

            Layout.alignment: Qt.AlignHCenter
        }

        RotatedMarquee {
            Layout.fillWidth: true
            height: root.marqueeHeight

            text: root.trackText
            richText: true
            font: root.textFont
            color: root.foregroundColor
            angle: 90

            running: root.visible && (!root.marqueeOnHover || root.hovered)
        }
    }
}
