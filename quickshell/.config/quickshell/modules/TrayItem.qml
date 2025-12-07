import QtQuick
import Quickshell.Services.SystemTray

Rectangle {
    width: 50
    height: icon.height
    color: "transparent"

    property SystemTrayItem systemTray: null

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
            cursorShape: Qt.PointingHandCursor

            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    systemTray.activate()
                } else if (event.button == Qt.RightButton) {
                    systemTray.display(mouse.x, mouse.y)
                    //systemTray.secondaryActivate()
                }
            }
        }
    }
}
