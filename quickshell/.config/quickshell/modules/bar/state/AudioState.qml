pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root

    property real volume: 0
    property bool muted: false
    property bool valid: false
    property bool everValid: false
    property bool usePactlFallback: false
    property bool snapshotQueued: false
    property string lastError: ""

    readonly property bool pipewireReady: Pipewire.ready
    readonly property var trackedSink: Pipewire.defaultAudioSink
    readonly property var sinkAudio: {
        const sink = root.trackedSink
        return sink ? sink.audio : null
    }

    function isFiniteNumber(value) {
        return typeof value === "number" && isFinite(value)
    }

    function clampVolume(value) {
        if (!root.isFiniteNumber(value))
            return 0
        return Math.max(0, value)
    }

    function applyState(nextVolume, nextMuted, source) {
        if (!root.isFiniteNumber(nextVolume)) {
            root.lastError = `Invalid ${source} volume`
            root.valid = false
            return
        }

        root.volume = root.clampVolume(nextVolume)
        root.muted = !!nextMuted
        root.valid = true
        root.everValid = true
        root.lastError = ""
        pipewireProbeTimer.stop()
    }

    function markInvalid(reason) {
        root.valid = false
        if (reason)
            root.lastError = reason
    }

    function switchToPactlFallback(reason) {
        if (root.usePactlFallback)
            return

        root.usePactlFallback = true
        root.lastError = reason || "PipeWire audio probe failed"
        root.valid = false
        pipewireProbeTimer.stop()
        root.scheduleSnapshot()
        if (!pactlSubscribeProc.running)
            pactlSubscribeProc.running = true
    }

    function updateFromPipewire() {
        if (root.usePactlFallback)
            return

        const sink = root.trackedSink
        const audio = root.sinkAudio

        if (!root.pipewireReady || !sink || !sink.ready || !audio) {
            root.markInvalid("PipeWire sink is not ready")
            if (!root.everValid)
                pipewireProbeTimer.restart()
            return
        }

        const nextVolume = audio.volume
        if (!root.isFiniteNumber(nextVolume)) {
            root.switchToPactlFallback("PipeWire volume was non-finite")
            return
        }

        root.applyState(nextVolume, audio.muted, "pipewire")
    }

    function applyPactlSnapshot(output) {
        const text = String(output || "")
        const volumeMatch = text.match(/Volume:[^\n]*?\/\s*([0-9]+)%/)
        const muteMatch = text.match(/Mute:\s+(yes|no)/)

        if (!volumeMatch || !muteMatch) {
            root.markInvalid("Failed to parse pactl snapshot")
            return
        }

        const nextVolume = parseInt(volumeMatch[1], 10) / 100
        root.applyState(nextVolume, muteMatch[1] === "yes", "pactl")
    }

    function scheduleSnapshot() {
        if (pactlSnapshotProc.running) {
            root.snapshotQueued = true
            return
        }

        pactlSnapshotProc.running = true
    }

    function maybeDrainQueuedSnapshot() {
        if (!root.snapshotQueued || pactlSnapshotProc.running)
            return

        root.snapshotQueued = false
        root.scheduleSnapshot()
    }

    function increase() {
        if (!volumeUpProc.running)
            volumeUpProc.running = true
    }

    function decrease() {
        if (!volumeDownProc.running)
            volumeDownProc.running = true
    }

    onPipewireReadyChanged: root.updateFromPipewire()
    onTrackedSinkChanged: root.updateFromPipewire()

    Component.onCompleted: {
        root.updateFromPipewire()
        if (!root.valid)
            pipewireProbeTimer.start()
    }

    PwObjectTracker {
        objects: root.trackedSink ? [root.trackedSink] : []
    }

    Timer {
        id: pipewireProbeTimer
        interval: 1200
        repeat: false
        onTriggered: {
            if (!root.usePactlFallback && !root.everValid)
                root.switchToPactlFallback("PipeWire audio probe timed out")
        }
    }

    Timer {
        id: pactlRestartTimer
        interval: 1000
        repeat: false
        onTriggered: {
            if (root.usePactlFallback && !pactlSubscribeProc.running)
                pactlSubscribeProc.running = true
        }
    }

    Connections {
        target: root.trackedSink
        ignoreUnknownSignals: true

        function onReadyChanged() {
            root.updateFromPipewire()
        }
    }

    Connections {
        target: root.sinkAudio
        ignoreUnknownSignals: true

        function onVolumesChanged() {
            root.updateFromPipewire()
        }

        function onMutedChanged() {
            root.updateFromPipewire()
        }
    }

    Process {
        id: pactlSnapshotProc
        command: [
            "sh",
            "-lc",
            "pactl get-sink-volume @DEFAULT_SINK@ && pactl get-sink-mute @DEFAULT_SINK@"
        ]
        running: false

        stdout: StdioCollector {
            onStreamFinished: root.applyPactlSnapshot(text)
        }

        onExited: root.maybeDrainQueuedSnapshot()
    }

    Process {
        id: pactlSubscribeProc
        command: ["pactl", "subscribe"]
        running: false

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const line = String(data || "").trim()
                if (line === "")
                    return

                if (
                    line.includes("on sink") ||
                    line.includes("on source") ||
                    line.includes("on server") ||
                    line.includes("on card")
                ) {
                    root.scheduleSnapshot()
                }
            }
        }

        onStarted: root.scheduleSnapshot()

        onExited: {
            if (root.usePactlFallback)
                pactlRestartTimer.restart()
        }
    }

    Process {
        id: volumeUpProc
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "1%+"]
        running: false
    }

    Process {
        id: volumeDownProc
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "1%-"]
        running: false
    }
}
