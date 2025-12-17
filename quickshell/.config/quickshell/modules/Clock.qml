import QtQuick
import Quickshell
import QtQuick.Controls

Item {
    id: root

    implicitWidth: timeText.implicitWidth
    implicitHeight: timeText.implicitHeight

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: timeText.text = formatTime()
    }

    function formatTime() {
        const now = new Date();
        const datePart = Qt.formatDate(now, "dd-MM");
        const yearPart = Qt.formatDate(now, "yyyy");
        const seconds = now.getSeconds();
        const timePart = seconds % 2 == 0 ? Qt.formatTime(now, "HH mm") : Qt.formatTime(now, "HH:mm");
        return datePart + "\n" + yearPart + "\n" + timePart;
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
    }

    Component.onCompleted: {
        timeText.text = formatTime();
    }
}
