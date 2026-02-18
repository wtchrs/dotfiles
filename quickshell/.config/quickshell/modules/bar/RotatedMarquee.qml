import QtQuick
import qs.configs

Item {
    id: root

    property alias text: info1.text
    property color color: Config.theme.fg
    property font font: Qt.font({ family: Config.font.text, pixelSize: 13 })
    property bool running: true

    clip: true

    onRunningChanged: textContainer.reset()

    Item {
        id: textContainer
        implicitWidth: parent.width
        implicitHeight: marquee.running ? info1.implicitWidth * 2 + textSpace : info1.implicitHeight

        property bool shouldMarquee: info1.implicitWidth > root.height
        property int textSpace: 30

        function reset() {
            textContainer.y = 0
            if (running && textContainer.shouldMarquee)
                marquee.restart()
        }

        RotatedText {
            id: info1
            onTextChanged: textContainer.reset()
        }

        RotatedText {
            id: info2
            y: info1.implicitWidth + parent.textSpace
            visible: textContainer.shouldMarquee
        }

        SequentialAnimation {
            id: marquee
            running: textContainer.shouldMarquee && root.running
            loops: Animation.Infinite

            NumberAnimation {
                target: textContainer
                property: "y"
                from: 0
                to: -info2.y
                duration: info2.y * 30
            }
            ScriptAction {
                script: textContainer.y = 0
            }
            PauseAnimation {
                duration: 2000
            }
        }
    }

    component RotatedText: Text {
        text: root.text
        font: root.font
        color: root.color
        transform: [
            Rotation { angle: 90 },
            Translate { x: (root.width + implicitHeight) / 2 }
        ]
    }
}
