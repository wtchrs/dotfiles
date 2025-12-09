import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: root
    width: 50
    height: container.height

    property var barWindow: null

    Column {
        id: container
        spacing: 5

        Network {
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
        }

        Repeater {
            model: SystemTray.items
            delegate: TrayItem {
                systemTray: modelData
                barWindow: root.barWindow
            }
        }
    }
}
