pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Controls
    property bool enabled: true
    property int restartBackoff: 800

    // Connection state
    property bool connected: false
    property string lastStderr: ""
    property string lastParseError: ""

    // State mirrored from the niri event-stream
    // Updated via WorkspacesChanged / Workspace* events
    property var workspaces: []
    // Updated via WindowsChanged / Window* events
    property var windows: []

    // Convenience: focused window id
    property var focusedWindowId: null

    // Raw event hook for optional upstream handling
    signal eventReceived(var event)

    function parseJsonSafe(s) {
        try {
            return JSON.parse((s || "").trim())
        } catch (e) {
            root.lastParseError = String(e)
            return null
        }
    }

    function optStr(v) {
        if (v === null || v === undefined) return ""
        const s = String(v)
        return s
    }

    function cloneObj(o) {
        // Shallow clone is enough for plain IPC objects
        return Object.assign({}, o)
    }

    function setWorkspaces(list) {
        root.workspaces = Array.isArray(list) ? list.map(root.cloneObj) : []
    }

    function setWindows(list) {
        root.windows = Array.isArray(list) ? list.map(root.cloneObj) : []
        const f = (Array.isArray(root.windows) ? root.windows : []).find(w => w && w.is_focused)
        root.focusedWindowId = f ? f.id : null
    }

    function patchWorkspaces(mapper) {
        const cur = Array.isArray(root.workspaces) ? root.workspaces : []
        root.workspaces = cur.map(ws => ws ? mapper(root.cloneObj(ws)) : ws)
    }

    function patchWindows(mapper) {
        const cur = Array.isArray(root.windows) ? root.windows : []
        root.windows = cur.map(w => w ? mapper(root.cloneObj(w)) : w)
        const f = (Array.isArray(root.windows) ? root.windows : []).find(w => w && w.is_focused)
        root.focusedWindowId = f ? f.id : null
    }

    function upsertWindow(winObj) {
        if (!winObj || winObj.id === null || winObj.id === undefined)
            return

        const incoming = root.cloneObj(winObj)
        let cur = Array.isArray(root.windows) ? root.windows.slice() : []
        cur = cur.map(root.cloneObj)

        // If a window is focused, clear focus on all others.
        if (incoming.is_focused) {
            cur = cur.map(w => Object.assign({}, w, { is_focused: false }))
            root.focusedWindowId = incoming.id
        }

        let found = false
        for (let i = 0; i < cur.length; i++) {
            if (cur[i] && cur[i].id === incoming.id) {
                cur[i] = Object.assign({}, cur[i], incoming)
                found = true
                break
            }
        }
        if (!found)
            cur.push(incoming)

        root.windows = cur
    }

    function removeWindow(id) {
        if (id === null || id === undefined)
            return

        const cur = Array.isArray(root.windows) ? root.windows : []
        root.windows = cur.filter(w => w && w.id !== id).map(root.cloneObj)

        if (root.focusedWindowId === id)
            root.focusedWindowId = null

        // Mitigate event reordering: drop workspace references to the closed window.
        const wsCur = Array.isArray(root.workspaces) ? root.workspaces : []
        root.workspaces = wsCur.map(ws => {
            if (!ws) return ws
            if (ws.active_window_id === id)
                return Object.assign({}, ws, { active_window_id: null })
            return root.cloneObj(ws)
        })
    }

    function applyEventObject(ev) {
        // Workspaces
        if (ev.WorkspacesChanged) {
            setWorkspaces(ev.WorkspacesChanged.workspaces)
            return
        }
        if (ev.WorkspaceUrgencyChanged) {
            const id = ev.WorkspaceUrgencyChanged.id
            const urgent = !!ev.WorkspaceUrgencyChanged.urgent
            patchWorkspaces(ws => (ws.id === id) ? Object.assign(ws, { is_urgent: urgent }) : ws)
            return
        }
        if (ev.WorkspaceActiveWindowChanged) {
            const wid = ev.WorkspaceActiveWindowChanged.workspace_id
            const awid = ("active_window_id" in ev.WorkspaceActiveWindowChanged)
                ? ev.WorkspaceActiveWindowChanged.active_window_id
                : null
            patchWorkspaces(ws => (ws.id === wid) ? Object.assign(ws, { active_window_id: awid }) : ws)
            return
        }
        if (ev.WorkspaceActivated) {
            const id = ev.WorkspaceActivated.id
            const focused = !!ev.WorkspaceActivated.focused

            const cur = Array.isArray(root.workspaces) ? root.workspaces : []
            const target = cur.find(ws => ws && ws.id === id)
            if (!target)
                return

            const out = target.output // optional output name
            const outName = (out === null || out === undefined) ? "" : String(out)

            patchWorkspaces(ws => {
                // Only one active workspace per output.
                if (outName !== "" && String(ws.output || "") === outName)
                    ws.is_active = (ws.id === id)

                // focused=true updates the global focused workspace.
                if (focused)
                    ws.is_focused = (ws.id === id)

                return ws
            })
            return
        }

        // Windows
        if (ev.WindowsChanged) {
            setWindows(ev.WindowsChanged.windows)
            return
        }
        if (ev.WindowOpenedOrChanged) {
            upsertWindow(ev.WindowOpenedOrChanged.window)
            return
        }
        if (ev.WindowClosed) {
            removeWindow(ev.WindowClosed.id)
            return
        }
        if (ev.WindowFocusChanged) {
            const id = ("id" in ev.WindowFocusChanged) ? ev.WindowFocusChanged.id : null
            patchWindows(w => Object.assign(w, { is_focused: (id !== null && id !== undefined && w.id === id) }))
            root.focusedWindowId = (id === null || id === undefined) ? null : id
            return
        }
        if (ev.WindowUrgencyChanged) {
            const id = ev.WindowUrgencyChanged.id
            const urgent = !!ev.WindowUrgencyChanged.urgent
            patchWindows(w => (w.id === id) ? Object.assign(w, { is_urgent: urgent }) : w)
            return
        }

        // Ignore other events...
    }

    function handleEventLine(line) {
        const s = String(line || "").trim()
        if (s === "")
            return

        const ev = root.parseJsonSafe(s)
        if (!ev)
            return

        root.eventReceived(ev)
        root.applyEventObject(ev)
    }

    function start() {
        if (!root.enabled)
            return
        if (!eventProc.running)
            eventProc.running = true
    }

    function stop() {
        restartTimer.stop()
        root.connected = false
        if (eventProc.running)
            eventProc.running = false
    }

    onEnabledChanged: {
        if (enabled) start()
        else stop()
    }

    Component.onCompleted: {
        if (enabled) start()
    }

    Timer {
        id: restartTimer
        interval: root.restartBackoff
        repeat: false
        onTriggered: root.start()
    }

    Process {
        id: eventProc
        command: ["niri", "msg", "--json", "event-stream"]
        running: false

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => root.handleEventLine(data)
        }

        stderr: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const t = String(data || "").trim()
                if (t !== "") root.lastStderr = t
            }
        }

        onStarted: {
            root.connected = true
        }

        onExited: (exitCode, exitStatus) => {
            root.connected = false
            if (root.enabled)
                restartTimer.restart()
        }
    }
}
