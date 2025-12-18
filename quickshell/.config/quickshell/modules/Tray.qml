import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: root
    width: 50
    implicitHeight: container.implicitHeight

    required property var barWindow

    ColumnLayout {
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
