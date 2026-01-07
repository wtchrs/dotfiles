import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    id: root
    implicitWidth: 50
    implicitHeight: icon.height
    color: "transparent"

    property SystemTrayItem systemTray: null
    property var barWindow: null

    Image {
        id: icon
        anchors.centerIn: parent
        width: 16
        height: 16
        source: systemTray.icon
    }

    MouseArea {
        id: iconMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: event => {
            console.log("Item clicked:", systemTray)
            if (event.button === Qt.LeftButton) {
                systemTray.activate()
            } else if (event.button == Qt.RightButton) {
                const pos = mapToItem(null, event.x, event.y)
                systemTray.display(barWindow, pos.x, pos.y)
            }
        }
    }

    TrayItemMenu {
        trayItem: root
        iconMouseArea: iconMouseArea
    }
}
