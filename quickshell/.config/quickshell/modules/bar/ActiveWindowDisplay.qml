import QtQuick
import Quickshell
import qs.configs
import qs.niri

Item {
    id: root
    implicitWidth: Config.bar.width
    implicitHeight: 10
    clip: true

    property var niri: NiriEventStream

    readonly property string outputName: root.QsWindow?.window?.screen?.name || ""

    readonly property var activeWorkspace: {
        const wsAll = (root.niri && Array.isArray(root.niri.workspaces)) ? root.niri.workspaces : []
        if (!root.outputName)
            return null
        return wsAll.find(ws => ws && String(ws.output || "") === root.outputName && !!ws.is_active) || null
    }

    readonly property var activeWindowId: {
        const ws = root.activeWorkspace
        if (!ws) return null
        return ("active_window_id" in ws) ? ws.active_window_id : null
    }

    readonly property string resolvedTitle: {
        const id = root.activeWindowId
        if (id === null || id === undefined)
            return ""

        const wins = (root.niri && Array.isArray(root.niri.windows)) ? root.niri.windows : []
        const w = wins.find(x => x && x.id === id) || null
        const t = (w && w.title !== null && w.title !== undefined) ? String(w.title) : ""
        return t
    }

    // Flicker guard: keep the previous title briefly if the id updates before the windows list.
    property string stableTitle: ""

    Timer {
        id: clearDelay
        interval: 180
        repeat: false
        onTriggered: {
            // Still unresolved: clear it.
            if (root.resolvedTitle === "")
                root.stableTitle = ""
        }
    }

    onResolvedTitleChanged: {
        if (root.resolvedTitle !== "") {
            root.stableTitle = root.resolvedTitle
            clearDelay.stop()
        } else {
            // No active window: clear immediately.
            if (root.activeWindowId === null || root.activeWindowId === undefined || !root.activeWorkspace) {
                root.stableTitle = ""
                clearDelay.stop()
            } else {
                // Possible event reordering: delay clearing slightly.
                clearDelay.restart()
            }
        }
    }

    readonly property bool shouldShowTitle: root.stableTitle !== ""

    Item {
        id: titleWrapper
        width: root.width
        implicitHeight: titleText.width

        states: [
            State {
                name: "empty"
                when: !root.shouldShowTitle
                PropertyChanges { target: titleWrapper; x: -titleWrapper.width }
            },
            State {
                name: "visible"
                when: root.shouldShowTitle
                PropertyChanges { target: titleWrapper; x: 0 }
            }
        ]

        transitions: [
            Transition {
                from: "*"; to: "*"
                SequentialAnimation {
                    NumberAnimation {
                        properties: "x"
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        ]

        Text {
            id: titleText
            text: root.stableTitle

            font.pixelSize: 14
            font.family: Config.font.text
            font.bold: true
            color: Config.theme.fg

            width: root.height
            clip: true
            elide: Text.ElideRight

            transform: [
                Rotation { angle: 90 },
                Translate { x: (root.width + titleText.implicitHeight) / 2 }
            ]
        }
    }
}
