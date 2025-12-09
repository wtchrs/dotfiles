import QtQuick
import QtQuick.Window
import Quickshell.Services.SystemTray

Rectangle {
    width: 50
    height: icon.height
    color: "transparent"

    property SystemTrayItem systemTray: null
    property var barWindow: null

    Image {
        id: icon
        anchors.centerIn: parent
        width: 16
        height: 16
        source: {
            let iconUrl = systemTray.icon
            console.log("System tray icon:", iconUrl)
            if (iconUrl.includes("?path=")) {
                const [name, path] = systemTray.icon.split("?path=")
                iconUrl = Qt.resolvedUrl(`${path}/${name.slice(name.lastIndexOf("/") + 1)}`)
            }
            console.log("Resolved url:", iconUrl)
            return iconUrl
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
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
    }
}
