import QtQuick
import qs.configs

Item {
    id: root
    clip: true

    // ----- Public API -----
    property string text: ""
    property bool richText: false
    property font font: Qt.font({ family: Config.font.text, pixelSize: 13 })
    property color color: Config.theme.fg

    property bool running: true
    property real angle: 90
    property int gap: 30
    property real pixelsPerSecond: 30
    property int pauseDuration: 2000
    property bool alwaysMarquee: false

    readonly property bool marqueeNeeded: alwaysMarquee || (label1.height > root.height)

    function reset() {
        scroller.y = 0
        if (root.running && root.marqueeNeeded)
            marquee.restart()
    }

    onRunningChanged: reset()
    onTextChanged: reset()
    onHeightChanged: reset()
    onGapChanged: reset()
    onPixelsPerSecondChanged: reset()
    onAngleChanged: reset()
    onAlwaysMarqueeChanged: reset()
    onRichTextChanged: reset()
    Component.onCompleted: reset()

    Item {
        id: scroller
        width: root.width

        height: root.marqueeNeeded ? (label1.height * 2 + root.gap) : label1.height

        RotatedLabel {
            id: label1
            angle: root.angle
            text: root.text
            richText: root.richText
            font: root.font
            color: root.color

            // Specify for stable measurement even outside of the layout
            width: implicitWidth
            height: implicitHeight

            anchors.horizontalCenter: parent.horizontalCenter
            y: 0
        }

        RotatedLabel {
            id: label2
            angle: root.angle
            text: root.text
            richText: root.richText
            font: root.font
            color: root.color

            width: implicitWidth
            height: implicitHeight

            anchors.horizontalCenter: parent.horizontalCenter
            y: label1.height + root.gap

            // label2 only makes sense if `root.marqueeNeeded` is true
            visible: root.marqueeNeeded
        }
    }

    SequentialAnimation {
        id: marquee
        running: root.running && root.marqueeNeeded
        loops: Animation.Infinite

        NumberAnimation {
            target: scroller
            property: "y"
            from: 0
            to: -label2.y

            // distance(px) / speed(px/s) = seconds → ms
            duration: Math.max(1, (label2.y * 1000) / Math.max(1, root.pixelsPerSecond))
        }

        ScriptAction { script: scroller.y = 0 }

        PauseAnimation { duration: root.pauseDuration }
    }
}
