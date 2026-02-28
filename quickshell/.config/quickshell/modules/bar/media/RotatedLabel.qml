import QtQuick
import qs.configs

Item {
    id: root

    // ----- Public API -----
    property string text: ""
    property font font: Qt.font({ family: Config.font.text, pixelSize: 13 })
    property color color: Config.theme.fg
    property real angle: 90
    property bool richText: false

    // for layout/measurement
    readonly property real naturalWidth: (Math.abs(angle) % 180 === 0) ? t.implicitWidth : t.implicitHeight
    readonly property real naturalHeight: (Math.abs(angle) % 180 === 0) ? t.implicitHeight : t.implicitWidth

    implicitWidth: naturalWidth
    implicitHeight: naturalHeight

    readonly property alias textItem: t

    Text {
        id: t
        anchors.centerIn: parent
        rotation: root.angle
        transformOrigin: Item.Center

        text: root.text
        textFormat: root.richText ? Text.RichText : Text.PlainText
        font: root.font
        color: root.color
    }
}
