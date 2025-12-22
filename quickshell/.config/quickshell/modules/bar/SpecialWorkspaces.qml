import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

Item {
    id: root
    implicitWidth: 50
    implicitHeight: container.implicitHeight

    property var activeSpecialWorkspace: null

    readonly property int focusedWorkspaceId: Hyprland.focusedWorkspace?.id || 0

    readonly property var iconMap: ({
        "chat": "",
        "music": "󰎇",
        "default": ""
    })

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
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activespecialv2") {
                hyprctlProc.running = true;
            }
        }
    }

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

    ColumnLayout {
        id: container
        width: 50
        spacing: 6

        Repeater {
            model: root.specialWs

            delegate: Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter

                readonly property int wsId: modelData.id
                readonly property string wsName: modelData.name.replace("special:", "")

                text: root.iconMap[wsName] || root.iconMap["default"]

                font: {
                    pixelSize: 13
                    family: "Symbols Nerd Font"
                }
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
}
