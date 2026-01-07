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
        "music": "",
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

            delegate: Item {
                Layout.fillWidth: true
                implicitHeight: text.implicitHeight

                readonly property var ws: modelData
                readonly property string wsName: ws.name.replace("special:", "")
                readonly property bool isUrgent: ws ? ws.urgent : false
                readonly property bool isFocused: wsName === root.activeSpecialWorkspace

                Rectangle {
                    anchors.fill: parent
                    visible: isUrgent
                    color: "#1b1e28"
                }

                Text {
                    id: text
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: root.iconMap[wsName] || root.iconMap["default"]
                    font.pixelSize: 13
                    font.family: "Symbols Nerd Font"
                    color: isFocused ? "#FFFFFF" : isUrgent ? "#a994b8" : "#AAAAAA"
                }

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
