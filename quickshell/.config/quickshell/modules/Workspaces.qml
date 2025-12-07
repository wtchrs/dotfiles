import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

ColumnLayout {
    id: root
    width: 50
    spacing: 1

    readonly property var focusedWorkspaceId: Hyprland.focusedWorkspace.id

    readonly property var occupiedWs: {
        return Array.from(Hyprland.workspaces.values).sort((a, b) => a.id - b.id);
    }

    readonly property var visibleWorkspaces: {
        let workspaces = new Set();
        workspaces.add(focusedWorkspaceId);
        root.occupiedWs.forEach(ws => workspaces.add(ws.id));
        // Filter out special workspaces which have negative IDs
        return Array.from(workspaces).filter(id => id > 0).sort((a, b) => a - b);
    }

    onFocusedWorkspaceIdChanged: {
        Hyprland.refreshWorkspaces();
    }

    Repeater {
        model: root.visibleWorkspaces

        delegate: Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            readonly property int wsId: modelData
            text: wsId.toString()
            font.pixelSize: 14
            font.family: "Sarasa mono K"
            color: wsId === root.focusedWorkspaceId ? "#FFFFFF" : "#AAAAAA"

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
