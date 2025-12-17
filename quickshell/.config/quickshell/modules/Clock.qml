import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: container.width
    implicitHeight: container.height

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: reload()
    }

    Component.onCompleted: {
        reload()
    }

    function reload() {
        const now = new Date()
        dateText.text = Qt.formatDate(now, "dd-MM")
        yearText.text = Qt.formatDate(now, "yyyy")
        const timeFormat = now.getSeconds() % 2 == 0 ? "HH mm" : "HH:mm"
        timeText.text = Qt.formatTime(now, timeFormat);
    }

    ColumnLayout {
        id: container
        width: 50
        spacing: 0

        ClockText {
            id: dateText
        }

        ClockText {
            id: yearText
        }

        ClockText {
            id: timeText
            font.bold: true
        }
    }

    component ClockText: Text {
        color: "white"
        font.pixelSize: 13
        font.family: "Sarasa Mono K"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
