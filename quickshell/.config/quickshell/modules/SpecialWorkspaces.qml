import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

ColumnLayout {
    id: root
    width: 50
    spacing: 6

    property var activeSpecialWorkspace: null

    Process {
        id: hyprctlProc
        command: ["hyprctl", "monitors", "-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const monitors = JSON.parse(this.text);
                    const focusedMonitor = monitors.find(m => m.focused);

                    if (focusedMonitor && focusedMonitor.specialWorkspace) {
                        const specialW = focusedMonitor.specialWorkspace;
                        if (specialW.id !== 0 && specialW.name !== "") {
                            root.activeSpecialWorkspace = specialW.name.replace("special:", "");
                            console.log("active special workspace (Process Result):", specialW.name);
                            return;
                        }
                    }
                    root.activeSpecialWorkspace = null;
                } catch (e) {
                    console.error("JSON parsing error:", e);
                    root.activeSpecialWorkspace = null;
                }
            }
        }
    }

    Connections {
        target: Hyprland.events

        onActiveSpecialWorkspaceChanged: {
            console.log("Hyprland activespecial event received. Re-running hyprctl.");
            hyprctlProc.running = true;
        }
    }

    readonly property var focusedWorkspaceId: Hyprland.focusedWorkspace.id

    readonly property var iconMap: ({
        "chat": "",
        "music": "󰎇",
        "default": ""
    })

    readonly property var specialWs: {
        return Array.from(Hyprland.workspaces.values)
            .filter(ws => ws.id < 0)
            .filter(ws => ws.name !== "special:__HIDE_TEMP")
            .sort((a, b) => -(a.id - b.id));
    }

    onFocusedWorkspaceIdChanged: {
        Hyprland.refreshWorkspaces();
        hyprctlProc.running = true
    }

    Repeater {
        model: root.specialWs

        delegate: Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            readonly property int wsId: modelData.id
            readonly property string wsName: modelData.name.replace("special:", "")
            text: root.iconMap[wsName] || root.iconMap["default"]
            font.pixelSize: 13
            font.family: "Symbols Nerd Font"
            color: wsName === root.activeSpecialWorkspace ? "#FFFFFF" : "#AAAAAA"

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Hyprland.dispatch(`togglespecialworkspace ${wsName}`);
                    hyprctlProc.running = true
                }
            }
        }
    }
}
