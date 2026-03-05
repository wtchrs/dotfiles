import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.configs
import qs.niri

Item {
    id: root
    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    property var niri: NiriEventStream

    // On click: optionally focus the monitor hosting this bar, then switch workspace.
    property bool focusMonitorOnClick: true

    readonly property string outputName: root.QsWindow?.window?.screen?.name || ""

    readonly property var iconMap: ({
        "1": "",
        "2": "",
        "3": "",
        "4": "",
        "5": "",
    })

    function shellEscape(s) {
        const v = (s === null || s === undefined) ? "" : String(s)
        return "'" + v.replace(/'/g, "'\"'\"'") + "'"
    }

    // niri display model:
    // - hide empty workspaces (active_window_id == null), except the active one on this output
    // - reindex visible entries as 1..N for labeling
    readonly property var displayModel: {
        const wsAll = (root.niri && Array.isArray(root.niri.workspaces)) ? root.niri.workspaces : []
        let list = wsAll.filter(ws => ws)

        if (root.outputName) {
            list = list.filter(ws => String(ws.output || "") === root.outputName)
        }

        list.sort((a, b) => (a.idx ?? 0) - (b.idx ?? 0))

        const out = []
        let di = 0

        for (const ws of list) {
            const isActive = !!ws.is_active
            const isEmpty = (ws.active_window_id === null || ws.active_window_id === undefined)

            if (isEmpty && !isActive)
                continue

            di++

            const name = (ws.name === null || ws.name === undefined) ? "" : String(ws.name)
            const hasName = name !== ""

            const ref = hasName ? name : String(ws.idx)

            let label = ""
            if (hasName) {
                label = root.iconMap[name] || name
            } else {
                const k = String(di)
                label = root.iconMap[k] || k
            }

            out.push({
                ws: ws,
                ref: ref,
                label: label,
            })
        }

        return out
    }

    // Action exec
    property var actionCommand: ["sh", "-c", "true"]

    Process {
        id: actionProc
        command: root.actionCommand
    }

    function focusWorkspace(entry) {
        if (!entry || !entry.ref || actionProc.running)
            return

        const parts = []
        if (root.focusMonitorOnClick && root.outputName) {
            parts.push(`niri msg action focus-monitor ${root.shellEscape(root.outputName)} >/dev/null 2>&1`)
        }
        parts.push(`niri msg action focus-workspace ${root.shellEscape(String(entry.ref))} >/dev/null 2>&1`)

        root.actionCommand = ["sh", "-c", parts.join(" ; ")]
        actionProc.running = true
    }

    ColumnLayout {
        id: container
        width: Config.bar.width
        spacing: 2

        Repeater {
            model: root.displayModel

            delegate: Item {
                Layout.fillWidth: true
                implicitHeight: text.implicitHeight

                readonly property var entry: modelData
                readonly property var ws: entry.ws

                readonly property bool isUrgent: ws ? !!ws.is_urgent : false
                readonly property bool isActive: ws ? !!ws.is_active : false
                readonly property bool isFocused: ws ? !!ws.is_focused : false

                Rectangle {
                    anchors.fill: parent
                    visible: isUrgent
                    color: "#1b1e28"
                }

                Text {
                    id: text
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: entry.label
                    font.family: Config.font.text
                    font.pixelSize: 13

                    // Priority: focused (global) > active (this output) > urgent
                    color: isFocused ? "#FFFFFF"
                          : isActive  ? "#DDDDDD"
                          : isUrgent  ? "#a994b8"
                          : "#AAAAAA"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.focusWorkspace(entry)
                }
            }
        }
    }
}
