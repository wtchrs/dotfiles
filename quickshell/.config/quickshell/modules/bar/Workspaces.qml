import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Item {
    id: root
    implicitWidth: 50
    implicitHeight: container.implicitHeight

    readonly property int focusedWorkspaceId: Hyprland.focusedWorkspace?.id || 0

    readonly property var occupiedWs: {
        return Array.from(Hyprland.workspaces.values).sort((a, b) => a.id - b.id);
    }

    readonly property var workspaceMap: {
        let map = {};
        Hyprland.workspaces.values.forEach(ws => {
            map[ws.id] = ws;
        });
        return map;
    }

    readonly property var visibleWorkspaces: {
        let workspaces = new Set([1, 2, 3, 4, 5]);
        workspaces.add(focusedWorkspaceId);
        root.occupiedWs.forEach(ws => workspaces.add(ws.id));
        // Filter out special workspaces which have negative IDs
        return Array.from(workspaces).filter(id => id > 0).sort((a, b) => a - b);
    }

    readonly property var iconMap: ({
        "1": "",
        "2": "",
        "3": "",
        "4": "",
        "5": "",
    })

    onFocusedWorkspaceIdChanged: {
        Hyprland.refreshWorkspaces();
    }

    ColumnLayout {
        id: container
        width: 50
        spacing: 2

        Repeater {
            model: root.visibleWorkspaces

            delegate: Item {
                Layout.fillWidth: true
                implicitHeight: text.implicitHeight

                readonly property int wsId: modelData
                readonly property var ws: root.workspaceMap[wsId]
                readonly property bool isUrgent: ws ? ws.urgent : false
                readonly property bool isFocused: wsId === root.focusedWorkspaceId

                Rectangle {
                    anchors.fill: parent
                    visible: isUrgent
                    color: "#1b1e28"
                }

                Text {
                    id: text
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: iconMap[wsId] || wsId.toString()
                    font.pixelSize: 13
                    font.family: "Sarasa mono K"
                    color: isFocused ? "#FFFFFF" : isUrgent ? "#a994b8" : "#AAAAAA"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hyprland.dispatch(`workspace ${parent.wsId}`);
                    }
                }
            }
        }
    }
}
