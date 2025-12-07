import QtQuick
import Quickshell
import QtQuick.Controls

Item {
    id: root

    implicitWidth: timeText.implicitHeight
    implicitHeight: timeText.implicitWidth

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: timeText.text = formatTime()
    }

    function formatTime() {
        var now = new Date();
        var datePart = Qt.formatDate(now, "dd-MM-yyyy");
        var timePart = Qt.formatTime(now, "HH mm");

        return datePart + "\n" + timePart;
    }

    Text {
        id: timeText
        text: formatTime()

        color: "white"
        font.pixelSize: 13
        font {
            pixelSize: 14
            family: "Sarasa Mono K"
        }
        horizontalAlignment: Text.AlignHCenter

        transform: [
            Rotation { angle: 90 },
            Translate { x: (root.width + timeText.implicitHeight) / 2 }
        ]
    }

    Component.onCompleted: {
        timeText.text = formatTime();
    }
}
